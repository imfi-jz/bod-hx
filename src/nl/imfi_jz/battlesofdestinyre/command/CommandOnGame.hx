package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.minecraft_api.Command;

abstract class CommandOnGame implements Command {
	private final initializedGames:Multitude<InitializedGame>;

    public function new(initializedGames) {
        this.initializedGames = initializedGames;
    }

    public function getInitializedGames() {
        return initializedGames;
    }
}