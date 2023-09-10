package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.battlesofdestinyre.game.event.base.StringChangeEvent;

class PlayerChangeTeamEvent extends StringChangeEvent {
    private final game:Game;
    private final playerName:String;
    private final stateKey:StateKey;
    
    public function new(playerName:String, stateKey, initializedGame, game) {
        super(stateKey, initializedGame);

        this.game = game;
        this.playerName = playerName;
        this.stateKey = stateKey;
    }

	private function handle(previousValue:Null<String>, newValue:Null<String>) {
        // TODO: Add PlayerLeaveGameEvent when newValue == null?

        if(isValidTeamName(newValue)){

            game.executeCommand('team', ['join', newValue, playerName]);

            if(previousValue == null){
                new PlayerJoinGameEvent(game, getInitializedGame(), playerName).handle();
            }
            else {
                if(!new Team(previousValue, getInitializedGame(), game).getOnlinePlayers().any()){
                    game.executeCommand('team', ['remove', previousValue]);
                }
            }
        }
        else {
            getInitializedGame().getOnlinePlayers().find((player) -> player.getName() == playerName)?.value?.tell('The team name $newValue is invalid');
            
            if(previousValue == newValue){
                getInitializedGame().getMemoryGameState().setString(stateKey, null);
            }
            else {
                getInitializedGame().getMemoryGameState().setString(stateKey, previousValue);
            }
        }
    }

    private function isValidTeamName(newValue:Null<String>) {
        return newValue != null
            && newValue.length > 0
            && newValue.length <= 10
            && Math.isNaN(Std.parseFloat(newValue));
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