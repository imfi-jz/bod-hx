package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

abstract class StringArrayChangeEvent extends StateChangeEvent<Array<String>> {
    
    public function new(
        gameStateChangeListener:GameStateChangeListener,
        stateKey:StateKey,
        sharedMemory:SharedMemory<Dynamic>
    ) {
        gameStateChangeListener.setStringArrayChangeHandler(stateKey, sharedMemory, handle);
    }
}