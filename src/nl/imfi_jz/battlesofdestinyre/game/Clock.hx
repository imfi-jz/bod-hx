package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.game.event.CommonGameEventData;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.game.event.TickEvent;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Scheduler;

class Clock {
    private final eventData:CommonGameEventData;
    private final scheduler:Scheduler;
    private final stageName:String;
    
    public function new(eventData, scheduler, stageName) {
        this.eventData = eventData;
        this.scheduler = scheduler;
        this.stageName = stageName;
    }

    public function start() {
        Debugger.log("Starting " + eventData.memoryGameState.getName() + "'s clock in stage " + stageName);

        if(stageName == null){
            Debugger.warn("Stage name is null, not starting clock");
        }
        else {
            new TickEvent(eventData, this, stageName);

            final currentSecondsRemaining = eventData.memoryGameState.getFloat(StateKey.stageSecondsRemaining(stageName));
            scheduleNextTick(currentSecondsRemaining);
        }
    }

    public function stop() {
        Debugger.log("Stopping " + eventData.memoryGameState.getName() + "'s clock in stage " + stageName);
        
        new UnhandledTickEvent(eventData, stageName);
    }

    public function scheduleNextTick(currentSecondsRemaining:Float) {
        final secondsBetweenTicks = eventData.memoryGameState.getFloat(StateKey.SECONDS_PER_TICK);

        scheduler.executeAfterSeconds(
            secondsBetweenTicks,
            () -> {
                eventData.memoryGameState.setFloat(
                    StateKey.stageSecondsRemaining(stageName),
                    currentSecondsRemaining - secondsBetweenTicks
                );
            }
        );
    }
}