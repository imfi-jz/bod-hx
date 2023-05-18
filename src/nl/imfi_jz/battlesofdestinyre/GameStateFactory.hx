package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.state.FileGameState;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.battlesofdestinyre.state.CombinedGameState;

class GameStateFactory {

    public static inline function createGameState(name:String, plugin:Plugin):CombinedGameState {
        return new CombinedGameState(
            new SharedMemoryGameState(
                name,
                plugin.getSharedPluginMemory(),
                plugin.getNameCapitals()
            ),
            new FileGameState(
                cast plugin.getFileSystemManager().getYmlFile(
                    name,
                    ["games"],
                    null,
                    true
                )
            )
        );
    }
}