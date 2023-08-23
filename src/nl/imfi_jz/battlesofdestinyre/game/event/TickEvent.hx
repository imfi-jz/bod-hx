package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;

class TickEvent extends FloatChangeEvent {
    private final clock:Clock;
    private final memoryGameState:SharedMemoryGameState;

    public function new(gameStateChangeListener:GameStateChangeListener, floatMemory:SharedMemory<Float>, clock, memoryGameState) {
        super(StateKey.SECONDS_REMAINING, floatMemory, gameStateChangeListener);
        
        this.clock = clock;
        this.memoryGameState = memoryGameState;
    }
    
	private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Ticking");

        if(currentSecondsRemaining != null){
            if(currentSecondsRemaining >= 0){
                clock.scheduleNextTick(currentSecondsRemaining);
            }
            else {
                Debugger.log("Stage time is up. Should switch stage");
                switchToNextStage();
            }
        }

        
    }

    private function switchToNextStage() {
        final currentStage = memoryGameState.getString(StateKey.STAGE);
        final nextStage = memoryGameState.getString(StateKey.stageNextStage(currentStage));

        if(nextStage == null){
            Debugger.log("No next stage found. Game is over");
            // TODO: reset players to the state they were in before the game started
            // TODO: mark game as finished?
        }
        else memoryGameState.setString(StateKey.STAGE, nextStage);
    }
}

class UnhandledTickEvent extends TickEvent {
    public function new(gameStateChangeListener:GameStateChangeListener, floatMemory:SharedMemory<Float>) {
        super(gameStateChangeListener, floatMemory, null, null);
    }
    
    override private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Unhandled tick");
    }
}