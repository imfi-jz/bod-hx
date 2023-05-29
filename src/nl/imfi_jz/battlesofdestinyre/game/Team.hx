package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.World;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;

class Team {
    
	private final memoryGameState:SharedMemoryGameState;
    private final gameStateChangeListener:GameStateChangeListener;
    private final stringMemory:SharedMemory<String>;
    private final teamKey:String;

    private function new(teamKey, memoryGameState, stringMemory, gameStateChangeListener) {
        this.teamKey = teamKey;
        this.memoryGameState = memoryGameState;
        this.gameStateChangeListener = gameStateChangeListener;
        this.stringMemory = stringMemory;
    }

    public function addPlayer(playerName:String) {
        final stateKey = StateKey.playerTeam(playerName);
        gameStateChangeListener.setStringChangeHandler(stateKey, stringMemory);
        memoryGameState.setString(stateKey, teamKey);
    }

    public function getKey():String {
        return teamKey;
    }

    public static function getTeamsPresetInGame(
        gameName:String,
        game:Game,
        memoryGameState:SharedMemoryGameState,
        stringMemory:SharedMemory<String>,
        gameStateChangeListnener:GameStateChangeListener
    ):Multitude<Team> {
        final worlds:Multitude<World> = game.getWorlds();
        final players:Multitude<Player> = worlds.reduce([], (players, world) -> players.concat(world.getPlayers()));

        return players.reduce([], (teams, player) -> {
            final teamKey:String = memoryGameState.getString(StateKey.playerTeam(player.getName()));
            
            if(teamKey == null){
                return teams;
            }
            else return teams.concat([new Team(teamKey, memoryGameState, stringMemory, gameStateChangeListnener)]);
        });
    }

    public static function generate(
        memoryGameState:SharedMemoryGameState,
        stringMemory:SharedMemory<String>,
        gameStateChangeListnener:GameStateChangeListener
    ):Team {
        return new Team('1', memoryGameState, stringMemory, gameStateChangeListnener);
    }
}