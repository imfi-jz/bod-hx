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
        final clock = new Clock(initializedGame, initializedGame.getMemoryGameState().getString(StateKey.STAGE));

        return [
            new PauseEvent(initializedGame, clock),
            new StageChangeEvent(initializedGame),
        ];
    }
}