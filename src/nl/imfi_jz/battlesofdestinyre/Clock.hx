package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.state.CombinedGameState;
import nl.imfi_jz.battlesofdestinyre.state.GameState;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class Clock {
    private final boolMemory:SharedMemory<Bool>;
    private final floatMemory:SharedMemory<Float>;
    private final gameState:GameState;
    private final scheduler:Scheduler;
    private final sharedMemoryKeyPrefix:String;
    
    public inline function new(sharedMemory:SharedPluginMemory, combinedGameState:CombinedGameState, scheduler) {
        this.scheduler = scheduler;
        boolMemory = sharedMemory.getBoolMemory();
        floatMemory = sharedMemory.getFloatMemory();
        this.sharedMemoryKeyPrefix = combinedGameState.sharedMemoryKeyPrefix;
        gameState = combinedGameState;

        boolMemory.valueChanged(
            sharedMemoryKeyPrefix + StateKey.PAUSED,
            pauseToggle
        );
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

        floatMemory.valueChanged(
            sharedMemoryKeyPrefix + StateKey.SECONDS_REMAINING,
            tick
        );

        final secondsRemaining = gameState.getSecondsRemaining();
        tick(secondsRemaining, secondsRemaining);
    }

    private function stop() {
        Debugger.log("Stopped game");
        
        floatMemory.valueChanged(
            sharedMemoryKeyPrefix + StateKey.SECONDS_REMAINING,
            null
        );
    }

    private function tick(previousSecondsRemaining:Float, currentSecondsRemaining:Float) {
        Debugger.log("Ticking");

        final secondsBetweenTicks = gameState.getSecondsBetweenTicks();

        // Retriggers itself if the game is not paused
        scheduler.executeAfterSeconds(
            secondsBetweenTicks,
            () -> {
                gameState.setSecondsRemaining(
                    Std.int(currentSecondsRemaining - secondsBetweenTicks)
                );
            }
        );
    }
}