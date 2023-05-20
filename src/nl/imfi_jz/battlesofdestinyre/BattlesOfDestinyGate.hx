package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.command.CreateGameCommand;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate;

@:keep
class BattlesOfDestinyGate implements Gate {

	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());

        Debugger.log("Debugger enabled");

        plugin.getRegisterer().registerCommand(new CreateGameCommand(plugin));
    }

	public function disable(plugin:Plugin) {
    }
}