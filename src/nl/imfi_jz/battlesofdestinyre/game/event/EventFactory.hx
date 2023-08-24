package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

class EventFactory {
    
    public function new() {
        
    }

    public function createEventsForGame(
        memoryGameState:SharedMemoryGameState,
        gameStateChangeListener:GameStateChangeListener,
        plugin:Plugin
    ):Array<StateChangeEvent<Any>> {
        final eventData = new CommonGameEventData(
            gameStateChangeListener,
            plugin.getSharedPluginMemory(),
            memoryGameState
        );
        
        final clock = new Clock(eventData, plugin.getScheduler(), memoryGameState.getString(StateKey.STAGE));

        return [
            new PauseEvent(eventData, clock),
            new StageChangeEvent(eventData, plugin.getScheduler()),
        ];
    }
}