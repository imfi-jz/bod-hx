package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

abstract class StringChangeEvent extends StateChangeEvent<String> {
    
    public function new(
        stateKey:StateKey,
        sharedMemory:SharedMemory<String>,
        gameStateChangeListener:GameStateChangeListener
    ) {
        super();
        gameStateChangeListener.setStringChangeHandler(stateKey, sharedMemory, handle);
    }
}