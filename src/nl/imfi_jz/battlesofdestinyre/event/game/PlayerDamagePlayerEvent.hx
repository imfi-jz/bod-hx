package nl.imfi_jz.battlesofdestinyre.event.game;

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

	public function occur(involvement:EventData) {

    }

	public function shouldCancel(involvement:EventData):Bool {
        final players:Multitude<Encounter> = involvement.getEncounters().filter((encounter) -> encounter.isA("player"));

        if(players.length > 1){
            return games.reduce(false, (cancel, game) -> {
                if(cancel) {
                    return true;
                }

                final playersInGame = game.getOnlinePlayers().reduce(0, (count, player) -> {
                    return count + players.filter((otherPlayer) -> player.matches(otherPlayer)).length;
                });

                return playersInGame < 2
                    || game.getMemoryGameState().getBool(StateKey.stageAllowPvp(
                            game.getMemoryGameState().getString(StateKey.STAGE)
                        )) != true;
            });
        }
        else return false;
	}
}