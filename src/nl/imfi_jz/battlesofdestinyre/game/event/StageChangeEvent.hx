package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.implementation.unchanging.ThreeDimensional.UnchangingThreeDimensional;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class StageChangeEvent extends StringChangeEvent {
    public function new(game) {
        super(StateKey.STAGE, game);
    }

	function handle(previousValue:Null<String>, newValue:Null<String>) {
        final game = getInitializedGame();
        final clock = new Clock(
            game,
            newValue
        );

        new PauseEvent(game, clock);

        if (!game.getMemoryGameState().getBool(StateKey.PAUSED)) {
            clock.start();
        }

        if(game.getMemoryGameState().getBool(StateKey.stageTeleportPlayersToCenter(newValue)) == true){
            Debugger.log("Teleporting players to center");

            final worldName = game.getMemoryGameState().getString(StateKey.CENTER_WORLD);
            final world = game.getPlugin().getGame().getWorlds().filter((world) -> world.getName() == worldName)[0];
            
            game.getTeams().each((team) -> team.getOnlinePlayers().each((player) -> {
                final memoryGameState = game.getMemoryGameState();
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