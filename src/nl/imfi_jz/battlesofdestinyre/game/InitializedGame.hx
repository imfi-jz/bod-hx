package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.World;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.FileGameState;

class InitializedGame {
    private final gameName:String;
    private final fileGameState:FileGameState;
    private final memoryGameState:SharedMemoryGameState;
    private final gameStateChangeListener:GameStateChangeListener;
    
    public function new(gameName, fileGameState, memoryGameState, gameStateChangeListener) {
        this.gameName = gameName;
        this.fileGameState = fileGameState;
        this.memoryGameState = memoryGameState;
        this.gameStateChangeListener = gameStateChangeListener;
    }

    public function getName():String {
        return gameName;
    }

    public function getFileGameState():FileGameState {
        return fileGameState;
    }

    public function getGameStateChangeListener():GameStateChangeListener {
        return gameStateChangeListener;
    }

    public function getMemoryGameState():SharedMemoryGameState {
        return memoryGameState;
    }

    public function getTeams(
        game:Game,
        stringMemory:SharedMemory<String>
    ):Multitude<Team> {
        final worlds:Multitude<World> = game.getWorlds();
        final players:Multitude<Player> = worlds.reduce([], (players, world) -> players.concat(world.getPlayers()));

        return players.reduce([], (teams, player) -> {
            final teamKey:String = memoryGameState.getString(StateKey.playerTeam(player.getName()));
            
            if(teamKey == null){
                return teams;
            }
            else return teams.concat([new Team(teamKey, this, stringMemory, game)]);
        });
    }
}