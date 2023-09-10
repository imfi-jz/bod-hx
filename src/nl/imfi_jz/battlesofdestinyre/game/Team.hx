package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.game.event.PlayerChangeTeamEvent;
import nl.imfi_jz.minecraft_api.World;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class Team {
	private final initializedGame:InitializedGame;
    private final game:Game;
    private final teamKey:String;

    public function new(teamKey:Null<String>, initializedGame:InitializedGame, game:Game) {
        this.initializedGame = initializedGame;
        this.game = game;

        this.teamKey = teamKey ?? initializedGame.getTeams().reduce(
            'A',
            (defaultName, team) -> team.getKey() == defaultName ? String.fromCharCode(StringTools.fastCodeAt(defaultName, 0) + 1) : defaultName
        );
    }

    public function addPlayer(playerName:String) {
        final stateKey = StateKey.playerTeam(playerName);
        
        new PlayerChangeTeamEvent(playerName, stateKey, initializedGame, game);

        initializedGame.getMemoryGameState().setString(stateKey, teamKey);
    }

    public function getOnlinePlayers():Multitude<Player> {
        final worlds:Multitude<World> = game.getWorlds();
        return worlds.reduce([], (players, world) -> players.concat(world.getPlayers())).filter(
            (player) -> initializedGame.getMemoryGameState().getString(StateKey.playerTeam(player.getName())) == teamKey
        );
    }

    public function getKey():String {
        return teamKey;
    }
}