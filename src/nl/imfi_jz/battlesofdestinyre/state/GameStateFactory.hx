package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.battlesofdestinyre.game.GameLoader;
import nl.imfi_jz.battlesofdestinyre.state.FileGameState;
import nl.imfi_jz.minecraft_api.Gate.Plugin;

class GameStateFactory {

    public inline function new() {
        
    }

    public inline function createGameState(name:String, plugin:Plugin):FileGameState {
        return new FileGameState(
            plugin.getFileSystemManager().getYmlFile(
                name,
                [GameLoader.STATE_FOLDER_NAME],
                null,
                true
            )
        );
    }
}