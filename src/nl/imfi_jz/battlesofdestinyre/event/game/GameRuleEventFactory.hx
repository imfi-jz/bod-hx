package nl.imfi_jz.battlesofdestinyre.event.game;

import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;

class GameRuleEventFactory {
    
    public function new() {
        
    }

    public function createEventsForGames(games:Multitude<InitializedGame>):Array<GameRuleEvent> {
        return [
            cast new PlayerDamagePlayerEvent(games),
        ];
    }
}