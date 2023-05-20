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

    public function getExistingGamesAsFileState(plugin:Plugin):Multitude<FileGameState> {
        return FileSystem.readDirectory(Path.join(plugin.getFileSystemManager().getDataFolderPath([STATE_FOLDER_NAME])))
            .filter((fileName:String) -> fileName.toLowerCase().lastIndexOf(STATE_FILE_EXTENSION) > 0)
            .map((fileName:String) -> new GameStateFactory().createGameState(
                fileName.substring(0, fileName.lastIndexOf('.')),
                plugin
            ));
    }

    public function initializeGame(fileGameState:FileGameState, plugin:Plugin):Void {
        final stateName = fileGameState.getName();
        final sharePluginMemory = plugin.getSharedPluginMemory();
        final memoryGameState = new SharedMemoryGameState(stateName, sharePluginMemory);

        final addTracker = (typeKey:String, trackFunction:(key:Array<String>) -> Void) -> {
            plugin.getSharedPluginMemory().getStringMemory().valueChanged(
                memoryGameState.getPrefixedSharedMemoryKey(['track$typeKey']),
                (previousKey, key) -> {
                    if(key != null && key.length > 0){
                        trackFunction(key.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
                    }
                }
            );
        };

        final stateChangeListener = new GameStateChangeListener(fileGameState);

        addTracker("bool", (key) -> {
            // Initialize the memory game state with the value found in the file game state
            memoryGameState.setBool(key, fileGameState.getBool(key));
            // Add a standard change handler that saves changes to file, which can be extended by creating a new GameStateChangeListener later
            stateChangeListener.setBoolChangeHandler(key, sharePluginMemory.getBoolMemory());
        });
        addTracker("float", (key) -> {
            memoryGameState.setFloat(key, fileGameState.getFloat(key));
            stateChangeListener.setFloatChangeHandler(key, sharePluginMemory.getFloatMemory());
        });
        addTracker("string", (key) -> {
            memoryGameState.setString(key, fileGameState.getString(key));
            stateChangeListener.setStringChangeHandler(key, sharePluginMemory.getStringMemory());
        });
        addTracker("stringarray", (key) -> {
            memoryGameState.setStringArray(key, fileGameState.getStringArray(key));
            stateChangeListener.setStringArrayChangeHandler(key, sharePluginMemory.getObjectMemory());
        });

        trackAllKnownKeys(sharePluginMemory, memoryGameState);

        registerGameName(stateName, sharePluginMemory.getObjectMemory(), sharePluginMemory.getStringMemory());

        new Clock(
            sharePluginMemory,
            plugin.getScheduler(),
            memoryGameState,
            stateChangeListener
        );
    }

	private function registerGameName(stateName:String, objectMemory:SharedMemory<Dynamic>, stringMemory:SharedMemory<String>) {
        final registeredGamesKey = ['games'];
        final registeredGames:Array<String> = objectMemory.getValue(SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, registeredGamesKey));

        if(registeredGames == null){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, registeredGamesKey),
                [stateName]
            );
        }
        else objectMemory.setValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, registeredGamesKey),
            registeredGames.concat([stateName])
        );

        stringMemory.setValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, ['last game added']),
            stateName
        );
	}


    private function trackAllKnownKeys(sharedPluginMemory:SharedPluginMemory, memoryGameState:SharedMemoryGameState): Void {
        final boolKeys:Multitude<StateKey> = StateKey.boolKeys();
        boolKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackbool']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final floatKeys:Multitude<StateKey> = StateKey.floatKeys().concat(StateKey.intKeys());
        floatKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackfloat']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final stringKeys:Multitude<StateKey> = StateKey.stringKeys();
        stringKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackstring']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
        
        final stringArrayKeys:Multitude<StateKey> = StateKey.stringArrayKeys();
        stringArrayKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackstringarray']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
    }
}