package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

abstract class FloatChangeEvent extends StateChangeEvent<Float> {
    
    public function new(
        stateKey:StateKey,
        sharedMemory:SharedMemory<Float>,
        gameStateChangeListener:GameStateChangeListener
    ) {
        super();
        gameStateChangeListener.setFloatChangeHandler(stateKey, sharedMemory, handle);
    }
}