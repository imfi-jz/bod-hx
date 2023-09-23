package nl.imfi_jz.battlesofdestinyre.game;

import haxe.exceptions.PosException;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Game;

class CommandExecutor {
    private static inline final PARSED_ARGUMENT_PREFIX = '<';
    private static inline final PARSED_ARGUMENT_SUFFIX = '>';
    private static inline final GAME_NAME_ARGUMENT = 'game_name';
    private static inline final KEY_SEPARATOR = '.'; // TODO: Maybe make this configurable

    private final game:Game;
    private final sharedMemoryGameState:SharedMemoryGameState;

    public function new(game, sharedMemoryGameState) {
        this.game = game;
        this.sharedMemoryGameState = sharedMemoryGameState;
    }

    public function executeUnparsedCommands(commands:Null<Array<String>>) {
        if(commands == null){
            Debugger.log('No commands to execute');
        }
        else {
            final commandsMult:Multitude<String> = commands;
            commandsMult.each(command -> executeUnparsedCommand(command));
        }
    }

    private function executeUnparsedCommand(command:String) {
        if(command == null || command.length <= 0) {
            Debugger.warn('Not executing empty command');
        }
        else {
            Debugger.log('Parsing command: $command');

            final parsedCommand = parseCommand(command);

            final commandName = parsedCommand.substring(0, parsedCommand.indexOf(' '));
            final commandArguments = parsedCommand.split(' ').slice(1);

            game.executeCommand(commandName, commandArguments);
        }
    }

    private function parseCommand(command:String):String {
        return parseApplicableTypes(
            parseGameName(command)
        );
    }

    private function parseGameName(command:String):String {
        Debugger.log('Parsing game name for command: $command');
        return StringTools.replace(command, PARSED_ARGUMENT_PREFIX + GAME_NAME_ARGUMENT + PARSED_ARGUMENT_SUFFIX, sharedMemoryGameState.getName());
    }

    private function parseApplicableTypes(command:String):String {
        return parseValue(command, (key) -> {
            final bool = sharedMemoryGameState.getBool(key);
            if(bool != null){
                return Std.string(bool);
            }
            else {
                final number = sharedMemoryGameState.getFloat(key);
                if(number != null){
                    if(Math.floor(number) == number) {
                        return Std.string(Math.floor(number));
                    }
                    else return Std.string(number);
                }
                else {
                    final string = sharedMemoryGameState.getString(key);
                    if(string != null){
                        return string;
                    }
                    else {
                        final keyAsString = PARSED_ARGUMENT_PREFIX + key.join(KEY_SEPARATOR) + PARSED_ARGUMENT_SUFFIX;
                        Debugger.warn('No value found for key $keyAsString in command "$command"');
                        return '';
                    }
                }
            }
        });
    }

    private function parseValue<T>(command:String, getValueAsString:(key:Array<String>)->String, recursionDepth = 100):String {
        if(recursionDepth > 0) {
            final prefix = PARSED_ARGUMENT_PREFIX;

            final startIndex = command.indexOf(prefix);
            if(startIndex >= 0) {
                final commandCutStart = command.substring(startIndex);
                final endIndex = startIndex + commandCutStart.indexOf(PARSED_ARGUMENT_SUFFIX) + PARSED_ARGUMENT_SUFFIX.length;

                final key = command.substring(startIndex + prefix.length, endIndex - PARSED_ARGUMENT_SUFFIX.length);
                final valueAsString = getValueAsString(key.split(KEY_SEPARATOR));
            
                final parsedCommand = command.substring(0, startIndex) + valueAsString + command.substring(endIndex);
            
                Debugger.log('Command "$command" was parsed to "$parsedCommand"');

                if(parsedCommand.indexOf(prefix) >= 0) {
                    return parseValue(parsedCommand, getValueAsString, recursionDepth - 1);
                }
                else return parsedCommand;
            }
            else return command;
        }
        else throw new PosException('Recursion depth exceeded while parsing command: $command');
    }
}