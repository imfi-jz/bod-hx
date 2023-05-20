package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.battlesofdestinyre.state.GameStateFactory;
import nl.imfi_jz.minecraft_api.Gate.Plugin;
import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class CreateGameCommand implements Command {
    public static inline final REQUIRED_PERMISSION_LEVEL = 4;
    public static inline final NO_PERMISSION_MESSAGE = "You do not have permission to use this command.";

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
        if(namePassesConstraints(gameName) && !gameNameExists(gameName)){
            createNewGame(gameName);
        }
    }

	private function gameNameExists(gameName:String):Bool {
        return new GameLoader().gameWithNameExists(gameName, plugin.getSharedPluginMemory().getObjectMemory());
	}

    private function issuesReported(arguments:StandardCollection<String>, ?executor:MessageReceiver):Bool {
        final gameName = getNameArgument(arguments);
        if(!namePassesConstraints(gameName)){
            executor?.tell("Please specify a name for the game (max 20 characters)");
            return true;
        }
        else if(gameNameExists(gameName)){
            executor?.tell("A game with this name already exists. Please choose a different name");
            return true;
        }
        else {
            return false;
        }
    }

    private function reportSuccess(gameName, ?executor:MessageReceiver) {
        executor.tell('Game $gameName created');
    }

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
        if(!issuesReported(arguments, executor)){
            execute(getNameArgument(arguments));
            reportSuccess(getNameArgument(arguments), executor);
        }
    }

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
        if(executor.getPermissionLevel() >= REQUIRED_PERMISSION_LEVEL){
            if(!issuesReported(arguments, executor)){
                execute(getNameArgument(arguments));
                reportSuccess(getNameArgument(arguments), executor);
            }
        }
        else {
            executor.tell(NO_PERMISSION_MESSAGE);
        }
    }

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {
        if(!issuesReported(arguments)){
            execute(getNameArgument(arguments));
        }
    }

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {
        if(!issuesReported(arguments)){
            execute(getNameArgument(arguments));
        }
    }
}