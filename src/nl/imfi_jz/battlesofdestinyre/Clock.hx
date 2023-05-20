package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.GameState;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class Clock {
    private final boolMemory:SharedMemory<Bool>;
    private final floatMemory:SharedMemory<Float>;
    private final scheduler:Scheduler;
    private final memoryGameState:GameState;
    private final stateChangeListener:GameStateChangeListener;
    
    public function new(sharedMemory:SharedPluginMemory, scheduler, memoryGameState, gameStateChangeListener) {
        this.scheduler = scheduler;
        boolMemory = sharedMemory.getBoolMemory();
        floatMemory = sharedMemory.getFloatMemory();
        this.memoryGameState = memoryGameState;
        this.stateChangeListener = gameStateChangeListener;

        this.stateChangeListener.setBoolChangeHandler(StateKey.PAUSED, boolMemory, pauseToggle);
    }

    private function pauseToggle(wasPaused:Null<Bool>, isPaused:Null<Bool>) {
        Debugger.log('Pause toggled. Paused was: $wasPaused, paused is: $isPaused');

        if(isPaused != null && !isPaused && (wasPaused == null || wasPaused)){
            start();
        }
        
        if(isPaused == null || isPaused){
            stop();
        }
    }

    private function start() {
        Debugger.log("Started game");

        stateChangeListener.setFloatChangeHandler(StateKey.SECONDS_REMAINING, floatMemory, tick);

        final secondsRemaining = memoryGameState.getFloat(StateKey.SECONDS_REMAINING);
        tick(secondsRemaining, secondsRemaining);
    }

    private function stop() {
        Debugger.log("Stopped game");
        
        stateChangeListener.setFloatChangeHandler(StateKey.SECONDS_REMAINING, floatMemory);
    }

    private function tick(previousSecondsRemaining:Float, currentSecondsRemaining:Float) {
        Debugger.log("Ticking");

        final secondsBetweenTicks = memoryGameState.getFloat(StateKey.SECONDS_BETWEEN_TICKS);

        // Retriggers itself if the game is not paused
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