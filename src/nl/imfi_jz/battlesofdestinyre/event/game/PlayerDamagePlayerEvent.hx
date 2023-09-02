package nl.imfi_jz.battlesofdestinyre.event.game;

import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.GameObject.Encounter;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Event.EventData;
import nl.imfi_jz.minecraft_api.Event.CancelingEvent;

class PlayerDamagePlayerEvent extends GameRuleEvent implements CancelingEvent {
    public function new(games) {
        super(games);
    }

	public function getName():String {
		return "EntityDamageByEntityEvent";
	}

	private function occurForGame(involvement:EventData, game:InitializedGame) {
        
    }

    private override function shouldCancelForGame(involvement:EventData, game:InitializedGame):Bool {
        final players:Multitude<Encounter> = involvement.getEncounters().filter((encounter) -> encounter.isA("player"));

        if(players.length > 1){
            final playersInGame = game.getOnlinePlayers().reduce(0, (count, player) -> {
                return count + players.filter((otherPlayer) -> player.matches(otherPlayer)).length;
            });

            // Cancel if the event is not about two players in the same game or if the game does not allow pvp
            return playersInGame < 2
                || game.getMemoryGameState().getBool(StateKey.stageAllowPvp(
                        game.getMemoryGameState().getString(StateKey.STAGE)
                    )) != true;
        }
        else return false;
    }
}