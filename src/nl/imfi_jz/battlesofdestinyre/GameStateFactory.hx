package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.state.FileGameState;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.battlesofdestinyre.state.CombinedGameState;

class GameStateFactory {

    public inline function new() {
        
    }

    public inline function createGameState(name:String, plugin:Plugin):CombinedGameState {
        final sharedMemoryState = new SharedMemoryGameState(
            name,
            plugin.getSharedPluginMemory(),
            plugin.getNameCapitals()
        );

        final fileState = new FileGameState(
            plugin.getFileSystemManager().getYmlFile(
                name,
                [GameLoader.STATE_FOLDER_NAME],
                null,
                true
            )
        );

        // TODO synchronizing the file state with the memory state should probably be moved elsewhere
        sharedMemoryState.setSecondsBetweenTicks(fileState.getSecondsBetweenTicks());
        sharedMemoryState.setSecondsRemaining(fileState.getSecondsRemaining());
        sharedMemoryState.setStage(fileState.getStage());

        return new CombinedGameState(
            sharedMemoryState,
            fileState
        );
    }
}