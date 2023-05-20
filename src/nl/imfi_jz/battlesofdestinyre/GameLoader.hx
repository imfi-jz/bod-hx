package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.GameStateFactory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.FileGameState;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import sys.FileSystem;
import haxe.io.Path;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Gate.Plugin;

class GameLoader {
    public static inline final STATE_FOLDER_NAME = "games";
    public static inline final STATE_FILE_EXTENSION = ".yml";
    
    public inline function new() {
        
    }

    public function getExistingGames(plugin:Plugin):Multitude<FileGameState> {
        return FileSystem.readDirectory(Path.join(plugin.getFileSystemManager().getDataFolderPath([STATE_FOLDER_NAME])))
            .filter((fileName:String) -> fileName.toLowerCase().lastIndexOf(STATE_FILE_EXTENSION) > 0)
            .map((fileName:String) -> new GameStateFactory().createGameState(
                fileName.substring(0, fileName.lastIndexOf('.')),
                plugin
            ));
    }

    public function initializeGame(fileGameState:FileGameState, plugin:Plugin):Void {
        final stateName = fileGameState.getName();
        final memoryGameState = new SharedMemoryGameState(stateName, plugin.getSharedPluginMemory(), plugin.getNameCapitals());

        final addTracker = (stateName:String, typeKey:String, trackFunction:(key:Array<String>) -> Void) -> {
            plugin.getSharedPluginMemory().getStringMemory().valueChanged(
                SharedMemoryGameState.getSharedMemoryKeyPrefix(stateName, ['track$typeKey']),
                (previousKey, key) -> {
                    if(key != null && key.length > 0){
                        trackFunction(key.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
                    }
                }
            );
        };

        addTracker(stateName, "bool", (key) -> {
            // Initialize the memory game state with the value found in the file game state
            memoryGameState.setBool(key, fileGameState.getBool(key));
            // Add a standard change handler that saves changes to file, which can be extended by creating a new GameStateChangeListener later
            new GameStateChangeListener(fileGameState, key).setBoolChangeHandler(plugin.getSharedPluginMemory().getBoolMemory());
        });
        // todo change to the above?
        addTracker(stateName, "float", (key) -> memoryGameState.trackFloat(key, fileGameState));
        addTracker(stateName, "string", (key) -> memoryGameState.trackString(key, fileGameState));
        addTracker(stateName, "stringarray", (key) -> memoryGameState.trackStringArray(key, fileGameState));

        trackAllKnownKeys(plugin.getSharedPluginMemory(), stateName);

        registerGameName(stateName, plugin.getSharedPluginMemory().getObjectMemory());

        /* new Clock(
            plugin.getSharedPluginMemory(),
            fileGameState, // fixme
            plugin.getScheduler()
        ); */
    }

	private function registerGameName(stateName:String, objectMemory:SharedMemory<Dynamic>) {
        final registeredGamesKey = ['games'];
        final registeredGames:Array<String> = objectMemory.getValue(SharedMemoryGameState.getSharedMemoryKeyPrefix(null, registeredGamesKey));

        if(registeredGames == null){
            objectMemory.setValue(
                SharedMemoryGameState.getSharedMemoryKeyPrefix(null, registeredGames),
                [stateName]
            );
        }
        else objectMemory.setValue(
            SharedMemoryGameState.getSharedMemoryKeyPrefix(null, registeredGames),
            registeredGames.concat([stateName])
        );
	}


    private function trackAllKnownKeys(sharedPluginMemory:SharedPluginMemory, stateName:String): Void {
        final boolKeys:Multitude<StateKey> = StateKey.boolKeys();
        boolKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            SharedMemoryGameState.getSharedMemoryKeyPrefix(stateName, ['trackbool']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final floatKeys:Multitude<StateKey> = StateKey.floatKeys().concat(StateKey.intKeys());
        floatKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            SharedMemoryGameState.getSharedMemoryKeyPrefix(stateName, ['trackfloat']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final stringKeys:Multitude<StateKey> = StateKey.stringKeys();
        stringKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            SharedMemoryGameState.getSharedMemoryKeyPrefix(stateName, ['trackstring']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
        
        final stringArrayKeys:Multitude<StateKey> = StateKey.stringArrayKeys();
        stringArrayKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            SharedMemoryGameState.getSharedMemoryKeyPrefix(stateName, ['trackstringarray']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
    }
}