package nl.imfi_jz.battlesofdestinyre.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.GameObject.Encounter;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.minecraft_api.Event.EventData;
import nl.imfi_jz.minecraft_api.Event.CancelingEvent;

class PlayerDamagePlayerEvent implements CancelingEvent {
    // TODO: Change implementation to be one event for all games (can't register the same event multiple times)
    private final game:InitializedGame;

    public function new(game) {
        this.game = game;
    }

	public function getName():String {
		return "EntityDamageByEntityEvent";
	}

	public function occur(involvement:EventData) {

    }

	public function shouldCancel(involvement:EventData):Bool {
        final players:Multitude<Encounter> = involvement.getEncounters().filter((encounter) -> encounter.isA("player"));

        if(players.length > 1){
            final playersInGame = game.getOnlinePlayers().reduce(0, (count, player) -> {
                return count + players.filter((otherPlayer) -> player.matches(otherPlayer)).length;
            });

            return playersInGame < 2
                || game.getMemoryGameState().getBool(StateKey.stageAllowPvp(
                        game.getMemoryGameState().getString(StateKey.STAGE)
                    )) != true;
        }
        else return false;
	}
}