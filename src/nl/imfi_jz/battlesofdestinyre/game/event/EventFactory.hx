package nl.imfi_jz.battlesofdestinyre.game.event;

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
        final boolMemory = plugin.getSharedPluginMemory().getBoolMemory();
        final floatMemory = plugin.getSharedPluginMemory().getFloatMemory();
        
        final clock = new Clock(floatMemory, plugin.getScheduler(), memoryGameState, gameStateChangeListener);

        return [
            new PauseEvent(gameStateChangeListener, boolMemory, memoryGameState, clock),
        ];
    }
}