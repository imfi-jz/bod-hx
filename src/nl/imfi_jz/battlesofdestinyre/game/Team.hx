package nl.imfi_jz.battlesofdestinyre.game;

import haxe.exceptions.NotImplementedException;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;

class Team {
	private final memoryGameState:SharedMemoryGameState;
    private final gameStateChangeListener:GameStateChangeListener;
    private final stringMemory:SharedMemory<String>;
    private final game:Game;
    private final teamKey:String;

    public function new(teamKey:Null<String>, initializedGame:InitializedGame, stringMemory:SharedMemory<String>, game:Game) {
        this.memoryGameState = initializedGame.getMemoryGameState();
        this.gameStateChangeListener = initializedGame.getGameStateChangeListener();
        this.stringMemory = stringMemory;
        this.game = game;

        this.teamKey = teamKey ?? Std.string(initializedGame.getTeams(game, stringMemory).reduce(
            1,
            (defaultName, team) -> Std.parseInt(team.getKey()) == defaultName ? defaultName + 1 : defaultName
        ));
    }

    public function addPlayer(playerName:String) {
        final stateKey = StateKey.playerTeam(playerName);
        gameStateChangeListener.setStringChangeHandler(stateKey, stringMemory);
        memoryGameState.setString(stateKey, teamKey);
    }

    public function getPlayers():Multitude<Player> {
        throw new NotImplementedException();
    }

    public function getKey():String {
        return teamKey;
    }
}