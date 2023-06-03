package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.game.InitializedGame;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.game.Team;
import nl.imfi_jz.battlesofdestinyre.game.GameLoader;
import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class JoinGameCommand implements Command {

	private final plugin:Plugin;
	private final objectMemory:SharedMemory<Dynamic>;
	private final initializedGamesByName:Map<String, InitializedGame>;

    public function new(plugin:Plugin, initializedGames:Multitude<InitializedGame>) {
		this.plugin = plugin;
		this.objectMemory = plugin.getSharedPluginMemory().getObjectMemory();
		this.initializedGamesByName = initializedGames.reduce(
			new Map<String, InitializedGame>(),
			(initializedGamesByName, initializedGame) -> {
				initializedGamesByName[initializedGame.getName()] = initializedGame;
				return initializedGamesByName;
			}
		);
    }

	public function getName():String {
		return "join";
	}

	private function getGameNameArgument(arguments:StandardCollection<String>):String {
		return arguments[0];
	}

	private function issuesReported(executor:MessageReceiver, arguments:StandardCollection<String>):Bool {
		final gameName:String = getGameNameArgument(arguments);
		if(gameName == null){
			final pluginNameCapitalsLower = plugin.getNameCapitals().toLowerCase();
			executor.tell('You must specify a game name to join');
			executor.tell('Usage: /hxp $pluginNameCapitalsLower join <game name>');
			return true;
		}
		else if(!gameExists(gameName)){
			executor.tell('No game with name $gameName exists');
			return true;
		}
		// TODO: Check if player is already in a game
		else return false;
	}

	private function gameExists(gameName:String):Bool {
		return new GameLoader().gameWithNameExists(gameName, objectMemory);
	}

	private function reportSuccess(executor:MessageReceiver, gameName:String, teamKey:String) {
		executor.tell('You have joined game $gameName in team $teamKey');
	}

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
		if(!issuesReported(executor, arguments)){
			executor.tell("Only players can join a game");
		}
	}

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
		if(!issuesReported(executor, arguments)){
			final gameName = getGameNameArgument(arguments);
			final stringMemory = plugin.getSharedPluginMemory().getStringMemory();
			final existingTeams = Team.getTeamsPresetInGame(
				gameName,
				plugin.getGame(),
				initializedGamesByName[gameName].getMemoryGameState(),
				stringMemory,
				initializedGamesByName[gameName].getGameStateChangeListener()
			);

			final team = existingTeams.any()
				? existingTeams.first().value
				: Team.generate(
					initializedGamesByName[gameName].getMemoryGameState(),
					stringMemory,
					initializedGamesByName[gameName].getGameStateChangeListener()
				);

			team.addPlayer(executor.getName());
			reportSuccess(executor, gameName, team.getKey());
		}
	}

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {}

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {}
}