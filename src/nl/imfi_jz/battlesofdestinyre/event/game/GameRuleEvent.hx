package nl.imfi_jz.battlesofdestinyre.event.game;

import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Event;

abstract class GameRuleEvent implements Event {
    private final games:Multitude<InitializedGame>;

    public function new(initializedGames:Multitude<InitializedGame>) {
        this.games = initializedGames;
    }

    public function getInitializedGames():Multitude<InitializedGame> {
        return games;
    }
}