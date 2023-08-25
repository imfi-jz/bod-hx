package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.Plugin;

class EventFactory {
    
    public function new() {
        
    }

    public function createEventsForGame(
        initializedGame:InitializedGame,
        plugin:Plugin
    ):Array<StateChangeEvent<Any>> {
        final eventData = new CommonGameEventData(
            initializedGame,
            plugin.getSharedPluginMemory()
        );
        
        final clock = new Clock(eventData, plugin.getScheduler(), initializedGame.getMemoryGameState().getString(StateKey.STAGE));

        return [
            new PauseEvent(eventData, clock),
            new StageChangeEvent(eventData, plugin.getScheduler()),
        ];
    }
}