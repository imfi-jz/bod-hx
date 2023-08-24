package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

class CommonGameEventData {
    public final gameStateChangeListener:GameStateChangeListener;
    public final sharedMemory:SharedPluginMemory;
    public final memoryGameState:SharedMemoryGameState;

    public inline function new(gameStateChangeListener, sharedMemory, memoryGameState) {
        this.gameStateChangeListener = gameStateChangeListener;
        this.sharedMemory = sharedMemory;
        this.memoryGameState = memoryGameState;
    }
}