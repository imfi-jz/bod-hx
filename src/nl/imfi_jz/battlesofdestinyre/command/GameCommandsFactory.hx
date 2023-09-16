package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.functional.collection.Collection.Multitude;

class GameCommandsFactory {
    public function new() {
        
    }

    public function createCommandsForGames(initializedGames:Multitude<InitializedGame>, plugin:Plugin):Array<CommandOnGame> {
        Debugger.log("Creating commands for games: " + initializedGames.map(game -> game.getName()));
        
        final pluginNameCapitalsLower = plugin.getNameCapitals().toLowerCase();

        return [
            new JoinGameCommand(
                plugin,
                initializedGames,
            ),
            new SetGamePropertyCommand(
                plugin.getSharedPluginMemory(),
                pluginNameCapitalsLower,
                initializedGames
            ),
            new SetNewGamePropertyCommand(
                plugin.getSharedPluginMemory(),
                pluginNameCapitalsLower,
                initializedGames
            ),
            new AddToGamePropertyCommand(
                plugin.getSharedPluginMemory(),
                pluginNameCapitalsLower,
                initializedGames
            ),
        ];
    }
}