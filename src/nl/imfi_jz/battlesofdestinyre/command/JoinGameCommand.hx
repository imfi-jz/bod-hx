package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.GameStateFactory;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
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

    public function new(plugin:Plugin) {
		this.plugin = plugin;
		this.objectMemory = plugin.getSharedPluginMemory().getObjectMemory();
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
			final gameStateChangeListener = new GameStateChangeListener(new GameStateFactory().createGameState(gameName, plugin), objectMemory);
			final memoryGameState = new SharedMemoryGameState(gameName, plugin.getSharedPluginMemory());
			final stringMemory = plugin.getSharedPluginMemory().getStringMemory();
			final existingTeams = Team.getTeamsPresetInGame(
				gameName,
				plugin.getGame(),
				memoryGameState,
				stringMemory,
				gameStateChangeListener
			);

			final team = existingTeams.any()
				? existingTeams.first().value
				: Team.generate(
					memoryGameState,
					stringMemory,
					gameStateChangeListener
				);

			team.addPlayer(executor.getName());
			reportSuccess(executor, gameName, team.getKey());
		}
	}

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {}

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {}
}