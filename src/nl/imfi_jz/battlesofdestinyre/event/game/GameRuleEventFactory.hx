package nl.imfi_jz.battlesofdestinyre.event.game;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;

class GameRuleEventFactory {
    
    public function new() {
        
    }

    public function createEventsForGames(initializedGames:Multitude<InitializedGame>):Array<GameRuleEvent> {
        Debugger.log("Creating game rule events for games: " + initializedGames.map(game -> game.getName()));

        return [
            cast new PlayerDamagePlayerEvent(initializedGames),
        ];
    }
}