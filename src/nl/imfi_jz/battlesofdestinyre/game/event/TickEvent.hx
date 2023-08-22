package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

class TickEvent extends FloatChangeEvent {
    private final clock:Clock;

    public function new(gameStateChangeListener:GameStateChangeListener, floatMemory:SharedMemory<Float>, clock) {
        super(StateKey.SECONDS_REMAINING, floatMemory, gameStateChangeListener);
        
        this.clock = clock;
    }
    
	private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Ticking");

        if(currentSecondsRemaining != null){
            if(currentSecondsRemaining >= 0){
                clock.scheduleNextTick(currentSecondsRemaining);
            }
            else {
                Debugger.log("Stage time is up. Should switch stage");
            }
        }

        
    }
}

class UnhandledTickEvent extends TickEvent {
    public function new(gameStateChangeListener:GameStateChangeListener, floatMemory:SharedMemory<Float>, clock) {
        super(gameStateChangeListener, floatMemory, clock);
    }
    
    override private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Unhandled tick");
    }
}