package nl.imfi_jz.battlesofdestinyre.game.event.base;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.Plugin;

class EventFactory {
    
    public function new() {
        
    }

    public function createEventsForGame(
        initializedGame:InitializedGame,
        plugin:Plugin
    ):Array<StateChangeEvent<Any>> {
        final clock = new Clock(initializedGame, initializedGame.getMemoryGameState().getString(StateKey.STAGE));

        // Return the root events (that are not created by other events)
        return [
            new PauseEvent(initializedGame, clock),
            new StageChangeEvent(initializedGame),
        ];
    }
}