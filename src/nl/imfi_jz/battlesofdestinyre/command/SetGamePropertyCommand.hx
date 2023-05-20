package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.Logger.ConsoleLogger;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.GameObject;
import nl.imfi_jz.minecraft_api.Command;

class SetGamePropertyCommand implements Command {

    private final sharedMemory:SharedPluginMemory;
    private final pluginNameCapitalLower:String;

    public function new(sharedMemory, pluginNameCapitalLower) {
        this.sharedMemory = sharedMemory;
        this.pluginNameCapitalLower = pluginNameCapitalLower;
    }
    
	public function getName():String {
        return "set";
	}

    private function execute(gameName:String, stateKey:String, value:String) {
        final sharedMemoryForValuesType = getSharedMemoryForValuesType(value);
        final sharedMemoryKey = SharedMemoryGameState.getAPrefixedSharedMemoryKey(
            gameName,
            stateKey.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        );
        sharedMemoryForValuesType.setValue(sharedMemoryKey, convertStringValueToMemoryType(value));
    }

    private function usagesReported(arguments:StandardCollection<String>, ?executor:MessageReceiver):Bool {
        // TODO check for spaces within value argument. Use parantheses to mark start and end.
        final usage = 'Usage: /hxp $pluginNameCapitalLower set <value> [to] <game name> <state key>';
        if(!currectNumberOfArguments(arguments)){
            executor?.tell('Invalid number of arguments. $usage');
            return false;
        }
        else if(!isValidStateKey(getStateKeyArgument(arguments))) {
            executor?.tell('Invalid state key. To set custom state keys, use: /hxp $pluginNameCapitalLower setcustom <value> [to] <game name> <state key>');
            return false;
        }
        else if(!gameExists(getGameNameArgument(arguments))) {
            executor?.tell('No game found with name "' + getGameNameArgument(arguments) + '". $usage');
            return false;
        }
        else return true;
    }

    private function reportSuccess(executor:MessageReceiver) {
        executor.tell("Successfully set game property");
    }

    private function currectNumberOfArguments(arguments:StandardCollection<String>):Bool {
        if(arguments.length >= 3) {
            if(argumentsContainsOptionalTo(arguments)) {
                return arguments.length >= 4;
            }
            else return true;
        }
        else return false;
    }

    private function argumentsContainsOptionalTo(arguments:StandardCollection<String>):Bool {
        return arguments[1].toLowerCase() == "to";
    }

    private function getGameNameArgument(arguments:StandardCollection<String>):String {
        if(argumentsContainsOptionalTo(arguments)) {
            return arguments[2];
        }
        else return arguments[1];
    }

    private function getValueArgument(arguments:StandardCollection<String>):String {
        return arguments[0];
    }

    private function getStateKeyArgument(arguments:StandardCollection<String>):String {
        if(argumentsContainsOptionalTo(arguments)) {
            return arguments.slice(3).join(" ");
        }
        else return arguments.slice(2).join(" ");
    }

    private function isValidStateKey(stateKey:String):Bool {   
        final keys:Multitude<StateKey> = StateKey.allKeys();
        return keys.reduce(false, (valid, key) -> {
            return valid || key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR) == stateKey;
        });
    }

    private function gameExists(gameName:String):Bool {
        return new GameLoader().gameWithNameExists(gameName, sharedMemory.getObjectMemory());
    }

    private function getSharedMemoryForValuesType(value:String):SharedMemory<Dynamic> {
        if(value.substring(0, 1) == '[' && value.substring(value.length - 1) == ']') {
            return sharedMemory.getObjectMemory();
        }
        else if(value.toLowerCase() == "true" || value.toLowerCase() == "false"){
            return sharedMemory.getBoolMemory();
        }
        else if(Std.parseFloat(value) == Math.NaN){
            return sharedMemory.getStringMemory();
        }
        else return sharedMemory.getStringMemory();
    }

    private function convertStringValueToMemoryType(value:String):Dynamic {
        if(value.substring(0, 1) == '[' && value.substring(value.length - 1) == ']') {
            return value.substring(1, value.length - 1).split(',').map((element) -> {
                return StringTools.trim(element);
            });
        }
        else if(value.toLowerCase() == "true" || value.toLowerCase() == "false"){
            return value.toLowerCase() == "true";
        }
        else if(Std.parseFloat(value) == Math.NaN){
            return value;
        }
        else return Std.parseFloat(value);
    }

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
        if(!usagesReported(arguments, executor)) {
            execute(getGameNameArgument(arguments), getStateKeyArgument(arguments), getValueArgument(arguments));
            reportSuccess(executor);
        }
    }

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
        if(executor.getPermissionLevel() >= CreateGameCommand.REQUIRED_PERMISSION_LEVEL){
            if(!usagesReported(arguments, executor)) {
                execute(getGameNameArgument(arguments), getStateKeyArgument(arguments), getValueArgument(arguments));
                reportSuccess(executor);
            }
        }
        else executor.tell(CreateGameCommand.NO_PERMISSION_MESSAGE);
    }

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {
        if(!usagesReported(arguments)) {
            execute(getGameNameArgument(arguments), getStateKeyArgument(arguments), getValueArgument(arguments));
        }
    }

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {
        if(!usagesReported(arguments)) {
            execute(getGameNameArgument(arguments), getStateKeyArgument(arguments), getValueArgument(arguments));
        }
    }
}