package nl.imfi_jz.battlesofdestinyre;

import sys.FileSystem;
import haxe.io.Path;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.state.CombinedGameState;

class GameLoader {
    public static inline final STATE_FOLDER_NAME = "games";
    public static inline final STATE_FILE_EXTENSION = ".yml";
    
    public inline function new() {
        
    }

    public function getExistingGames(plugin:Plugin):Multitude<CombinedGameState> {
        return FileSystem.readDirectory(Path.join(plugin.getFileSystemManager().getDataFolderPath([STATE_FOLDER_NAME])))
            .filter((fileName:String) -> fileName.toLowerCase().lastIndexOf(STATE_FILE_EXTENSION) > 0)
            .map((fileName:String) -> new GameStateFactory().createGameState(
                fileName.substring(0, fileName.lastIndexOf('.')),
                plugin
            ));
    }

    public inline function initializeGames(states:Multitude<CombinedGameState>, plugin:Plugin):Void {
        states.each((state:CombinedGameState) ->
            new Clock(
                plugin.getSharedPluginMemory(),
                state,
                plugin.getScheduler()
            )
        );
    }
}