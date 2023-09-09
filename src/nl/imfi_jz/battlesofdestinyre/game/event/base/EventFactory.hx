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

        // TODO: Loop through all keys of the game state file and create events based on those.
        // This is to prevent set values from not being tracked (when edited via the set command for example).

        return [
            new PauseEvent(initializedGame, clock),
            new StageChangeEvent(initializedGame),
        ];
    }
}