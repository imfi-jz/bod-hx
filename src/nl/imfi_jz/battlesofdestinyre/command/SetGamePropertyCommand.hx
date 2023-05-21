package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
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
    private static inline final ARGUMENT_WITH_SPACES_INDICATOR = '"';

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

    private function usagesReported(parsedArguments:StandardCollection<String>, ?executor:MessageReceiver):Bool {
        final usageArguments = '"<game name>.<state key>" "<value>"';
        final usage = 'Usage: /hxp $pluginNameCapitalLower set $usageArguments';
        if(!currectNumberOfArguments(parsedArguments)){
            executor?.tell('Invalid number of arguments. $usage');
            return true;
        }
        else if(getStateKeyArgument(parsedArguments).length <= 0){
            executor?.tell('No state key was given. $usage');
            return true;
        }
        else if(getValueArgument(parsedArguments).length <= 0){
            executor?.tell('No value was given. $usage');
            return true;
        }
        else if(!isValidStateKey(getStateKeyArgument(parsedArguments))) {
            executor?.tell('Invalid state key. To set custom state keys, use: /hxp $pluginNameCapitalLower setcustom $usageArguments');
            return true;
        }
        else if(!gameExists(getGameNameArgument(parsedArguments))) {
            executor?.tell('No game found with name "' + getGameNameArgument(parsedArguments) + '". $usage');
            return true;
        }
        else return false;
    }

    private function reportSuccess(executor:MessageReceiver) {
        executor.tell("Successfully set game property");
    }

    private function currectNumberOfArguments(parsedArguments:StandardCollection<String>):Bool {
        if(parsedArguments.length > 2){
            return StringTools.startsWith(parsedArguments[0], ARGUMENT_WITH_SPACES_INDICATOR)
                || StringTools.endsWith(parsedArguments[parsedArguments.length - 1], ARGUMENT_WITH_SPACES_INDICATOR);
        }
        else return parsedArguments.length == 2;
    }

    /**
        Takes the input arguments, which are split by space, and returns a new Array where the first element is <game name>.<state key> and the second element is <value>.
        In the input, <game>.<state key> and <value> should be surrounded by quotes if it contains spaces.
    **/
    private function parseArguments(arguments:StandardCollection<String>):Array<String> {
        if(arguments.length >= 2){
            final argumentsSplitByIndicator = arguments.join(" ")
                .split(ARGUMENT_WITH_SPACES_INDICATOR)
                .filter(str -> str.length > 0);

            if(argumentsSplitByIndicator.length == 1){
                return [arguments[0], arguments[1]];
            }
            else if(argumentsSplitByIndicator.length == 2){
                if(arguments[0].charAt(0) == ARGUMENT_WITH_SPACES_INDICATOR){
                    return [
                        argumentsSplitByIndicator[0],
                        argumentsSplitByIndicator[1].substring(1)
                    ];
                }
                else return [
                    argumentsSplitByIndicator[0].substring(0, argumentsSplitByIndicator[0].length - 1),
                    argumentsSplitByIndicator[1]
                ];
            }
            else return [
                argumentsSplitByIndicator[0],
                argumentsSplitByIndicator[2]
            ];
        }
        else return [];
    }

    private function getGameNameArgument(parsedArguments:StandardCollection<String>):String {
        return parsedArguments[0].substring(0, parsedArguments[0].indexOf(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
    }

    private function getValueArgument(parsedArguments:StandardCollection<String>):String {
        return parsedArguments[1];
    }

    private function getStateKeyArgument(parsedArguments:StandardCollection<String>):String {
        return parsedArguments[0].substring(parsedArguments[0].indexOf(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR) + 1);
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
        else if(Math.isNaN(Std.parseFloat(value))){
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
        else if(Math.isNaN(Std.parseFloat(value))){
            if(value == Std.string(null)){
                return null;
            }
            else return value;
        }
        else return Std.parseFloat(value);
    }

	public function executeByConsole(executor:ConsoleLogger, arguments:StandardCollection<String>) {
        final parsedArguments = parseArguments(arguments);
        Debugger.log("Parsed arguments: " + parsedArguments);
        if(!usagesReported(parsedArguments, executor)) {
            execute(getGameNameArgument(parsedArguments), getStateKeyArgument(parsedArguments), getValueArgument(parsedArguments));
            reportSuccess(executor);
        }
    }

	public function executeByPlayer(executor:Player, arguments:StandardCollection<String>) {
        if(executor.getPermissionLevel() >= CreateGameCommand.REQUIRED_PERMISSION_LEVEL){
            final parsedArguments = parseArguments(arguments);
            if(!usagesReported(parsedArguments, executor)) {
                execute(getGameNameArgument(parsedArguments), getStateKeyArgument(parsedArguments), getValueArgument(parsedArguments));
                reportSuccess(executor);
            }
        }
        else executor.tell(CreateGameCommand.NO_PERMISSION_MESSAGE);
    }

	public function executeByBlock(executor:Block, arguments:StandardCollection<String>) {
        final parsedArguments = parseArguments(arguments);
        if(!usagesReported(parsedArguments)) {
            execute(getGameNameArgument(parsedArguments), getStateKeyArgument(parsedArguments), getValueArgument(parsedArguments));
        }
    }

	public function executeByGameObject(executor:GameObject, arguments:StandardCollection<String>) {
        final parsedArguments = parseArguments(arguments);
        if(!usagesReported(parsedArguments)) {
            execute(getGameNameArgument(parsedArguments), getStateKeyArgument(parsedArguments), getValueArgument(parsedArguments));
        }
    }
}