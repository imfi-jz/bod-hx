package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate;

@:keep
class BattlesOfDestinyGate implements Gate {

	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());

        Debugger.log("H");

        // TODO construct existing states from file, keeping them in memory. And add newly created games' states to the list.
        final state = GameStateFactory.createGameState("test", plugin);

        new Clock(
            plugin.getSharedPluginMemory(),
            state,
            plugin.getScheduler()
        );
        
        state.setSecondsBetweenTicks(5);
        state.setSecondsRemaining(60);
        state.setStage("Test stage");
        state.setPaused(false);
    }

	public function disable(plugin:Plugin) {
        // TODO pause all games (probably)
    }
}