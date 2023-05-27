package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class PauseEvent extends BoolChangeEvent {
    private final clock:Clock;

    public function new(gameStateChangeListener:GameStateChangeListener, boolMemory:SharedMemory<Bool>, memoryGameState:SharedMemoryGameState, clock) {
        super(StateKey.PAUSED, boolMemory, gameStateChangeListener);

        this.clock = clock;
    }

	function handle(wasPaused:Null<Bool>, isPaused:Null<Bool>) {
        Debugger.log('Pause toggled. Paused was: $wasPaused, paused is: $isPaused');

        if(isPaused != null && !isPaused && (wasPaused == null || wasPaused)){
            clock.start();
        }
        
        if(isPaused == null || isPaused){
            clock.stop();
        }
    }
}