package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.battlesofdestinyre.game.GameLoader;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class JoinGameCommand implements Command {

	private final objectMemory:SharedMemory<Dynamic>;
    
    public function new(objectMemory) {
        this.objectMemory = objectMemory;
    }

	public function getName():String {
		return "join";
	}

	private function getGameNameArgument(arguments:StandardCollection<String>):String {
		return null; // TODO
	}

	private function issuesReported(executor:MessageReceiver, arguments:StandardCollection<String>):Bool {
		final gameName:String = getGameNameArgument(arguments);
		if(!gameExists(gameName)){
			executor.tell('No game with name $gameName exists');
			return true;
		}
		else return false;
	}

	private function gameExists(gameName:String):Bool {
		return new GameLoader().gameWithNameExists(gameName, objectMemory);
	}

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
		if(!issuesReported(executor, arguments)){
			executor.tell("Only players can join a game");
		}
	}

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
		if(!issuesReported(executor, arguments)){
			// TODO
		}
	}

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {}

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {}
}