package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class TickEvent extends FloatChangeEvent {
    private final clock:Clock;
    private final stageName:String;

    public function new(game, clock, stageName) {
        super(StateKey.stageSecondsRemaining(stageName), game);
        
        this.clock = clock;
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
        final nextStage = getInitializedGame().getMemoryGameState().getString(StateKey.stageNextStage(stageName));

        clock.stop();

        if(nextStage == null){
            Debugger.log("No next stage found. Game is over");
            /* TODO:
            - reset players to the state they were in before the game started
            - mark game as finished?
            - unregister events bound to this game?
            - remove game name from players' tags
            - remove players' team via command
            */
        }
        else {
            getInitializedGame().getMemoryGameState().setString(StateKey.STAGE, nextStage);
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