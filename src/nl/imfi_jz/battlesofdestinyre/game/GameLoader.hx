package nl.imfi_jz.battlesofdestinyre.game;

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
    private static inline final STATE_FILE_EXTENSION = ".yml";

    private static final INITIALIZED_GAMES_MEMORY_KEY = ['games'];
    private static final LAST_GAME_ADDED_MEMORY_KEY = ['lastgameadded'];
    
    public inline function new() {
        
    }

    public function getExistingGamesAsFileStates(plugin:Plugin):Multitude<FileGameState> {
        final gamesDirectory = Path.join(plugin.getFileSystemManager().getDataFolderPath([STATE_FOLDER_NAME]));
        if(FileSystem.exists(gamesDirectory)){
            return FileSystem.readDirectory(gamesDirectory)
                .filter((fileName:String) -> fileName.toLowerCase().lastIndexOf(STATE_FILE_EXTENSION) > 0)
                .map((fileName:String) -> new GameStateFactory().createGameState(
                    fileName.substring(0, fileName.lastIndexOf('.')),
                    plugin
                ));
        }
        else return [];
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

        final stateChangeListener = new GameStateChangeListener(fileGameState, sharePluginMemory.getObjectMemory());

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

        trackAllKnownKeys(sharePluginMemory, memoryGameState, fileGameState);

        registerGameName(stateName, sharePluginMemory.getObjectMemory(), sharePluginMemory.getStringMemory());

        new Clock(
            sharePluginMemory,
            plugin.getScheduler(),
            memoryGameState,
            stateChangeListener
        );
    }

	private function registerGameName(stateName:String, objectMemory:SharedMemory<Dynamic>, stringMemory:SharedMemory<String>) {
        final registeredGames:Array<String> = objectMemory.getValue(SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, INITIALIZED_GAMES_MEMORY_KEY));

        if(registeredGames == null){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, INITIALIZED_GAMES_MEMORY_KEY),
                [stateName]
            );
        }
        else objectMemory.setValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, INITIALIZED_GAMES_MEMORY_KEY),
            registeredGames.concat([stateName])
        );

        stringMemory.setValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, LAST_GAME_ADDED_MEMORY_KEY),
            stateName
        );
	}

    private function trackAllKnownKeys(sharedPluginMemory:SharedPluginMemory, memoryGameState:SharedMemoryGameState, fileGameState:FileGameState): Void {
        final boolKeys:Multitude<StateKey> = fileGameState.getAllBoolStateKeysPresent().concat(StateKey.boolKeys());
        boolKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackbool']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final floatKeys:Multitude<StateKey> = fileGameState.getAllFloatStateKeysPresent()
            .concat(StateKey.floatKeys().concat(StateKey.intKeys()));
        floatKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackfloat']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final stringKeys:Multitude<StateKey> = fileGameState.getAllStringStateKeysPresent().concat(StateKey.stringKeys());
        stringKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackstring']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
        
        final stringArrayKeys:Multitude<StateKey> = fileGameState.getAllStringArrayStateKeysPresent().concat(StateKey.stringArrayKeys());
        stringArrayKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackstringarray']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
    }

    public inline function gameWithNameExists(gameName:String, objectMemory:SharedMemory<Dynamic>):Bool {
        return objectMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GameLoader.INITIALIZED_GAMES_MEMORY_KEY)
        )?.contains(gameName);
    }

    public inline function getNameOfLastGameAdded(stringMemory:SharedMemory<String>):String {
        return stringMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GameLoader.LAST_GAME_ADDED_MEMORY_KEY)
        );   
    }
}