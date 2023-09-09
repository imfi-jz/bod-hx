package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.functional.collection.Collection.Multitude;

class GameCommandsFactory {
    public function new() {
        
    }

    public function createCommandsForGames(initializedGames:Multitude<InitializedGame>, plugin:Plugin):Array<CommandOnGame> {
        return [
            new JoinGameCommand(
                plugin,
                initializedGames,
            ),
            new SetGamePropertyCommand(
                plugin.getSharedPluginMemory(),
                plugin.getNameCapitals().toLowerCase(),
                initializedGames
            ),
        ];
    }
}