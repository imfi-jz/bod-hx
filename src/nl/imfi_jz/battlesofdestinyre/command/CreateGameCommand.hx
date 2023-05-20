package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.battlesofdestinyre.state.GameStateFactory;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class CreateGameCommand implements Command {
    private final plugin:Plugin;
    
    public function new(plugin) {
        this.plugin = plugin;
    }

	public function getName():String {
        return "new";
	}

    private inline function getNameArgument(arguments:StandardCollection<String>):String {
        return arguments.join(" ");
    }

    private inline function namePassesConstraints(gameName:String):Bool {
        return gameName.length > 0 && gameName.length < 20;
    }

	private function createNewGame(gameName:String) {
        final gameLoader = new GameLoader();
        final state = new GameStateFactory().createGameState(gameName, plugin);

        gameLoader.initializeGame(state, plugin);
	}

    private function execute(gameName:String) {
        if(namePassesConstraints(gameName)){
            createNewGame(gameName);
        }
    }

    private function report(executor:MessageReceiver, gameName:String) {
        if(namePassesConstraints(gameName)){
            executor.tell('Game $gameName created');
        }
        else {
            executor.tell("Please specify a name for the game (max 20 characters)");
        }
    }

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
        execute(getNameArgument(arguments));
        report(executor, getNameArgument(arguments));
    }

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
        if(executor.getPermissionLevel() >= 4){
            execute(getNameArgument(arguments));
            report(executor, getNameArgument(arguments));
        }
        else {
            executor.tell("You don't have permission to use this command");
        }
    }

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {
        execute(getNameArgument(arguments));
    }

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {
        execute(getNameArgument(arguments));
    }
}