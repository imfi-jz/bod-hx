package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate;

@:keep
class BattlesOfDestinyGate implements Gate {

	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());

        Debugger.log("Debugger enabled");

        final gameLoader = new GameLoader();
        gameLoader.initializeGames(gameLoader.getExistingGames(plugin), plugin);
    }

	public function disable(plugin:Plugin) {
        new GameLoader().getExistingGames(plugin).each((state) -> state.setPaused(true));
    }
}