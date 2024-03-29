package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.state.player.PlayerStateStorage;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.World;
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
    private final plugin:Plugin;
    private final commandExecutor:CommandExecutor;
    private final playerStateStorage:PlayerStateStorage;
    
    public function new(gameName, fileGameState, memoryGameState, gameStateChangeListener, plugin) {
        this.gameName = gameName;
        this.fileGameState = fileGameState;
        this.memoryGameState = memoryGameState;
        this.gameStateChangeListener = gameStateChangeListener;
        this.plugin = plugin;
        this.commandExecutor = new CommandExecutor(plugin.getGame(), memoryGameState);
        this.playerStateStorage = new PlayerStateStorage(plugin.getFileSystemManager().getYmlFile('player-states'));
    }

    public function getName():String {
        return gameName;
    }

    @:deprecated public function getFileGameState():FileGameState {
        return fileGameState;
    }

    public function getGameStateChangeListener():GameStateChangeListener {
        return gameStateChangeListener;
    }

    public function getMemoryGameState():SharedMemoryGameState {
        return memoryGameState;
    }

    public function getPlugin():Plugin {
        return plugin;
    }

    public function getCommandExecutor():CommandExecutor {
        return commandExecutor;
    }

    public function getCommandTag():String {
        return getCommandTagPrefix() + StringTools.replace(gameName, ' ', '-');
    }

    public inline function getCommandTagPrefix():String {
        return "bod-";
    }

    public function getPlayerStateStorage():PlayerStateStorage {
        return playerStateStorage;
    }

    public function getTeams():Multitude<Team> {
        final worlds:Multitude<World> = plugin.getGame().getWorlds();
        final players:Multitude<Player> = worlds.reduce([], (players, world) -> players.concat(world.getPlayers()));

        return players.reduce([], (teams, player) -> {
            final teamKey:String = memoryGameState.getString(StateKey.playerTeam(player.getName()));
            
            if(teamKey == null){
                return teams;
            }
            else return teams.concat([new Team(
                teamKey,
                this,
                plugin.getGame()
            )]);
        });
    }

    public function getOnlinePlayers():Multitude<Player> {
        return getTeams().reduce([], (players, team) -> players.concat(team.getOnlinePlayers()));
    }
}