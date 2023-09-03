package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.battlesofdestinyre.game.event.base.StringChangeEvent;

class PlayerChangeTeamEvent extends StringChangeEvent {
    private final game:Game;
    private final playerName:String;
    
    public function new(playerName:String, stateKey, initializedGame, game) {
        super(stateKey, initializedGame);

        this.game = game;
        this.playerName = playerName;
    }

	private function handle(previousValue:Null<String>, newValue:Null<String>) {
        if(previousValue == null){
            new PlayerJoinGameEvent(game, getInitializedGame(), playerName).handle();
        }
        else {
            game.executeCommand('team', ['join', newValue, playerName]);
            
            if(! new Team(previousValue, getInitializedGame(), game).getOnlinePlayers().any()){
                game.executeCommand('team', ['remove', previousValue]);
            }
        }
    }
}

class PlayerJoinGameEvent {
    private final game:Game;
    private final initializedGame:InitializedGame;
    private final playerName:String;

    public function new(game, initializedGame, playerName) {
        this.game = game;
        this.initializedGame = initializedGame;
        this.playerName = playerName;
    }

    public function handle() {
        game.executeCommand('tag', [playerName, 'add', initializedGame.getCommandTag()]);
    }
}