package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.implementation.unchanging.ThreeDimensional.UnchangingThreeDimensional;
import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class StageChangeEvent extends StringChangeEvent {
    private final eventData:CommonGameEventData;
    private final scheduler:Scheduler;
    
    public function new(eventData:CommonGameEventData, scheduler) {
        super(StateKey.STAGE, eventData.game);

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

        if (!eventData.game.getMemoryGameState().getBool(StateKey.PAUSED)) {
            clock.start();
        }

        if(eventData.game.getMemoryGameState().getBool(StateKey.stageTeleportPlayersToCenter(newValue)) == true){
            Debugger.log("Teleporting players to center");

            final worldName = eventData.game.getMemoryGameState().getString(StateKey.CENTER_WORLD);
            final world = getInitializedGame().getPlugin().getGame().getWorlds().filter((world) -> world.getName() == worldName)[0];
            
            getInitializedGame().getTeams().each((team) -> team.getOnlinePlayers().each((player) -> {
                final memoryGameState = getInitializedGame().getMemoryGameState();
                player.teleport(new UnchangingThreeDimensional(
                    memoryGameState.getFloat(StateKey.CENTER_X),
                    memoryGameState.getFloat(StateKey.CENTER_Y),
                    memoryGameState.getFloat(StateKey.CENTER_Z)
                ), world);

                Debugger.log("Teleported player " + player.getName() + " to center");
            }));
        }
    }
}