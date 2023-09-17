package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate.Game;

class CommandExecutor {
    private final game:Game;

    public function new(game:Game) {
        this.game = game;
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
            Debugger.log('Executing command: $command');

            final parsedCommand = parseCommand(command);

            final commandName = parsedCommand.substring(0, parsedCommand.indexOf(' '));
            final commandArguments = parsedCommand.split(' ').slice(1);

            game.executeCommand(commandName, commandArguments);
        }
    }

    private function parseCommand(command:String):String {
        // Make sure not to add any new spaces to the command
        // TODO
        return command;
    }
}