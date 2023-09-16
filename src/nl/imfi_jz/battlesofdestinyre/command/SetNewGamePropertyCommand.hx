package nl.imfi_jz.battlesofdestinyre.command;

import haxe.exceptions.NotImplementedException;
import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.MessageReceiver;

class SetNewGamePropertyCommand extends SetGamePropertyCommand {
    public static inline final NAME = 'setnew';

    public override function getName():String {
        return NAME;
    }
    
    private override function usagesReported(parsedArguments:StandardCollection<String>, ?executor:MessageReceiver):Bool {
        throw new NotImplementedException();
    }
}