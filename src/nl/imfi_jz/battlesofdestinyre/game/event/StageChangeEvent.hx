package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class StageChangeEvent extends StringChangeEvent {
    private final eventData:CommonGameEventData;
    private final scheduler:Scheduler;
    
    public function new(eventData:CommonGameEventData, scheduler) {
        super(StateKey.STAGE, eventData.sharedMemory.getStringMemory(), eventData.gameStateChangeListener);

        this.eventData = eventData;
        this.scheduler = scheduler;
    }

	function handle(previousValue:Null<String>, newValue:Null<String>) {
        final clock = new Clock(
            eventData,
            scheduler,
            newValue
        );

        new PauseEvent(eventData, clock);

        if (!eventData.memoryGameState.getBool(StateKey.PAUSED)) {
            clock.start();
        }
    }
}