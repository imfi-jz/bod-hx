package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.event.game.GameRuleEventFactory;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.event.game.GameRuleEvent;
import nl.imfi_jz.minecraft_api.Event;
import nl.imfi_jz.battlesofdestinyre.game.event.base.StateChangeEventFactory;
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

    public function initializeGame(fileGameState:FileGameState, plugin:Plugin):InitializedGame {
        final stateName = fileGameState.getName();
        final sharedPluginMemory = plugin.getSharedPluginMemory();
        final memoryGameState = new SharedMemoryGameState(stateName, sharedPluginMemory);
        final stateChangeListener = new GameStateChangeListener(fileGameState, sharedPluginMemory.getObjectMemory());

        addTrackabilityForGame(
            sharedPluginMemory,
            memoryGameState,
            fileGameState,
            stateChangeListener
        );

        trackAllKnownKeys(sharedPluginMemory, memoryGameState, fileGameState);

        registerGameName(stateName, sharedPluginMemory.getObjectMemory(), sharedPluginMemory.getStringMemory());

        final initializedGame = new InitializedGame(
            stateName,
            fileGameState,
            memoryGameState,
            stateChangeListener,
            plugin
        );

        new StateChangeEventFactory().createEventsForGame(
            initializedGame,
            plugin
        );

        if(!memoryGameState.getBool(StateKey.PAUSED)){
            memoryGameState.setBool(StateKey.PAUSED, true);
        }

        registerSpigotEventsAccosiatedWithGame(initializedGame, plugin);

        return initializedGame;
    }

    private function addTrackabilityForGame(
        sharedPluginMemory:SharedPluginMemory,
        memoryGameState:SharedMemoryGameState,
        fileGameState:FileGameState,
        stateChangeListener:GameStateChangeListener
    ) {
        final addTracker = (typeKey:String, trackFunction:(key:Array<String>) -> Void) -> {
            sharedPluginMemory.getStringMemory().valueChanged(
                memoryGameState.getPrefixedSharedMemoryKey(['track$typeKey']),
                (previousKey, key) -> {
                    if(key != null && key.length > 0){
                        trackFunction(key.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
                    }
                    else {
                        Debugger.warn('Tried to track unspecified $typeKey key');
                    }
                }
            );
        };

        addTracker("bool", (key) -> {
            // Add a standard change handler that saves changes to file, which can be extended by creating a new GameStateChangeListener later
            stateChangeListener.setBoolChangeHandler(key, sharedPluginMemory.getBoolMemory());
            // Initialize the memory game state with the value found in the file game state
            memoryGameState.setBool(key, fileGameState.getBool(key));
        });
        addTracker("float", (key) -> {
            stateChangeListener.setFloatChangeHandler(key, sharedPluginMemory.getFloatMemory());
            memoryGameState.setFloat(key, fileGameState.getFloat(key));
        });
        addTracker("string", (key) -> {
            stateChangeListener.setStringChangeHandler(key, sharedPluginMemory.getStringMemory());
            memoryGameState.setString(key, fileGameState.getString(key));
        });
        addTracker("stringarray", (key) -> {
            stateChangeListener.setStringArrayChangeHandler(key, sharedPluginMemory.getObjectMemory());
            memoryGameState.setStringArray(key, fileGameState.getStringArray(key));
        });
    }

    private function trackAllKnownKeys(sharedPluginMemory:SharedPluginMemory, memoryGameState:SharedMemoryGameState, fileGameState:FileGameState): Void {
        final boolKeys:Multitude<StateKey> = fileGameState.getAllBoolStateKeysPresent();
        boolKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackbool']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final floatKeys:Multitude<StateKey> = fileGameState.getAllFloatStateKeysPresent();
        floatKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackfloat']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));

        final stringKeys:Multitude<StateKey> = fileGameState.getAllStringStateKeysPresent();
        stringKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackstring']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
        
        final stringArrayKeys:Multitude<StateKey> = fileGameState.getAllStringArrayStateKeysPresent();
        stringArrayKeys.each((key) -> sharedPluginMemory.getStringMemory().setValue(
            memoryGameState.getPrefixedSharedMemoryKey(['trackstringarray']),
            key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        ));
    }

	private function registerGameName(stateName:String, objectMemory:SharedMemory<Dynamic>, stringMemory:SharedMemory<String>) {
        final registeredGames:Array<String> = objectMemory.getValue(SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GeneralMemoryKey.INITIALIZED_GAMES_MEMORY_KEY));

        if(registeredGames == null){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GeneralMemoryKey.INITIALIZED_GAMES_MEMORY_KEY),
                [stateName]
            );
        }
        else objectMemory.setValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GeneralMemoryKey.INITIALIZED_GAMES_MEMORY_KEY),
            registeredGames.concat([stateName])
        );

        stringMemory.setValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GeneralMemoryKey.LAST_GAME_ADDED_MEMORY_KEY),
            stateName
        );
	}

    public inline function gameWithNameExists(gameName:String, objectMemory:SharedMemory<Dynamic>):Bool {
        return objectMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GeneralMemoryKey.INITIALIZED_GAMES_MEMORY_KEY)
        )?.contains(gameName) == true;
    }

    public inline function getNameOfLastGameAdded(stringMemory:SharedMemory<String>):String {
        return stringMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, GeneralMemoryKey.LAST_GAME_ADDED_MEMORY_KEY)
        );   
    }
    
	private function registerSpigotEventsAccosiatedWithGame(initializedGame:InitializedGame, plugin:Plugin) {
        final registerer = plugin.getRegisterer();
        final events:Multitude<Event> = registerer.getRegisteredEvents();
        final existingGames = cast(events.filter(event -> event is GameRuleEvent).first()?.value, GameRuleEvent)?.getInitializedGames() ?? [];
        
        events.each(event -> event is GameRuleEvent ? registerer.unregisterEvent(event) : null);

        final eventsToRegister:Multitude<GameRuleEvent> = new GameRuleEventFactory().createEventsForGames([initializedGame].concat(existingGames));

        eventsToRegister.each(event -> registerer.registerEvent(event));
	}
}