package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.game.GameLoader;
import nl.imfi_jz.battlesofdestinyre.command.JoinGameCommand;
import nl.imfi_jz.battlesofdestinyre.command.SetGamePropertyCommand;
import nl.imfi_jz.battlesofdestinyre.command.CreateGameCommand;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate;

@:keep
class BattlesOfDestinyGate implements Gate {

	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());

        Debugger.log("Debugger enabled");

        final gameLoader = new GameLoader();
        final initializedGames = gameLoader.getExistingGamesAsFileStates(plugin)
            .map((state) -> gameLoader.initializeGame(state, plugin));

        plugin.getRegisterer().registerCommand(new CreateGameCommand(plugin));
        plugin.getRegisterer().registerCommand(new SetGamePropertyCommand(
            plugin.getSharedPluginMemory(),
            plugin.getNameCapitals().toLowerCase(),
            initializedGames
        ));
        plugin.getRegisterer().registerCommand(new JoinGameCommand(
            plugin,
            initializedGames,
        ));
    }

	public function disable(plugin:Plugin) {
    }
}