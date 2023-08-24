package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class TickEvent extends FloatChangeEvent {
    private final clock:Clock;
    private final eventData:CommonGameEventData;
    private final stageName:String;

    public function new(eventData:CommonGameEventData, clock, stageName) {
        super(StateKey.stageSecondsRemaining(stageName), eventData.sharedMemory.getFloatMemory(), eventData.gameStateChangeListener);
        
        this.clock = clock;
        this.eventData = eventData;
        this.stageName = stageName;
    }
    
	private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Ticking");

        if(currentSecondsRemaining == null || currentSecondsRemaining > 0){
            clock.scheduleNextTick(currentSecondsRemaining);
        }
        else if(currentSecondsRemaining != null && currentSecondsRemaining <= 0){
            Debugger.log("Stage time is up. Should switch stage");
            switchToNextStage();
        }
    }

    private function switchToNextStage() {
        final nextStage = eventData.memoryGameState.getString(StateKey.stageNextStage(stageName));

        clock.stop();

        if(nextStage == null){
            Debugger.log("No next stage found. Game is over");
            // TODO: reset players to the state they were in before the game started
            // TODO: mark game as finished?
        }
        else {
            eventData.memoryGameState.setString(StateKey.STAGE, nextStage);
        }
    }
}

class UnhandledTickEvent extends TickEvent {
    public function new(eventData, stageName) {
        super(eventData, null, stageName);
    }
    
    override private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Unhandled tick");
    }
}