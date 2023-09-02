package nl.imfi_jz.battlesofdestinyre.event.game;

import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Event;

abstract class GameRuleEvent implements CancelingEvent {
    private final games:Multitude<InitializedGame>;

    public function new(initializedGames:Multitude<InitializedGame>) {
        this.games = initializedGames;
    }

    public final function getInitializedGames():Multitude<InitializedGame> {
        return games;
    }

    private abstract function occurForGame(involvement:EventData, game:InitializedGame):Void;
    
    private function shouldCancelForGame(involvement:EventData, game:InitializedGame):Bool {
        return false;
    }

    public final function occur(involvement:EventData) {
        getInitializedGames().each((game) -> occurForGame(involvement, game));
    }

	public final function shouldCancel(involvement:EventData):Bool {
        return getInitializedGames().reduce(
            false,
            (shouldCancel, game) -> shouldCancel || shouldCancelForGame(involvement, game)
        );
	}
}