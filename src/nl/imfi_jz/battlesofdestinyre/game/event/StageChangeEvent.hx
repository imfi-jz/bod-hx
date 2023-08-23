package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;

// TODO: Remove?
class StageChangeEvent extends StringChangeEvent {
    private final memoryGameState:SharedMemoryGameState;
    
    public function new(stringMemory:SharedMemory<String>, gameStateChangeListener:GameStateChangeListener, memoryGameState:SharedMemoryGameState) {
        super(StateKey.STAGE, stringMemory, gameStateChangeListener);

        this.memoryGameState = memoryGameState;
    }

	function handle(previousValue:Null<String>, newValue:Null<String>) {

    }
}