package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.battlesofdestinyre.game.event.TickEvent;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class Clock {
    private final floatMemory:SharedMemory<Float>;
    private final scheduler:Scheduler;
    private final memoryGameState:SharedMemoryGameState;
    private final stateChangeListener:GameStateChangeListener;
    
    public function new(floatMemory:SharedMemory<Float>, scheduler, memoryGameState, gameStateChangeListener) {
        this.scheduler = scheduler;
        this.floatMemory = floatMemory;
        this.memoryGameState = memoryGameState;
        this.stateChangeListener = gameStateChangeListener;
    }

    public function start() {
        Debugger.log("Starting " + memoryGameState.getName() + "'s clock");

        new TickEvent(stateChangeListener, floatMemory, this, memoryGameState);

        scheduleNextTick(memoryGameState.getFloat(StateKey.SECONDS_REMAINING));
    }

    public function stop() {
        Debugger.log("Stopping " + memoryGameState.getName() + "'s clock");
        
        new UnhandledTickEvent(stateChangeListener, floatMemory);
    }

    public function scheduleNextTick(currentSecondsRemaining:Float) {
        final secondsBetweenTicks = memoryGameState.getFloat(StateKey.SECONDS_BETWEEN_TICKS);

        scheduler.executeAfterSeconds(
            secondsBetweenTicks,
            () -> {
                memoryGameState.setFloat(
                    StateKey.SECONDS_REMAINING,
                    currentSecondsRemaining - secondsBetweenTicks
                );
            }
        );
    }
}