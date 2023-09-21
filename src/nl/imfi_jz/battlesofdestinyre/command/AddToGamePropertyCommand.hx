package nl.imfi_jz.battlesofdestinyre.command;

import nl.imfi_jz.minecraft_api.TypeDefinitions.StandardCollection;
import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;

class AddToGamePropertyCommand extends SetGamePropertyCommand {

    public override function getName():String {
        return 'add';
    }

    private override function execute(gameName:String, stateKey:String, value:String) {
        final sharedMemoryForValuesType = getSharedMemoryForValuesType(value);
        final sharedMemoryKey = SharedMemoryGameState.getAPrefixedSharedMemoryKey(
            gameName,
            stateKey.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
        );
        final existingValue = sharedMemoryForValuesType.getValue(sharedMemoryKey);

        sharedMemoryForValuesType.setValue(sharedMemoryKey, existingValue + convertStringValueToMemoryType(value));
    }

    private override function usagesReported(parsedArguments:StandardCollection<String>, ?executor:MessageReceiver):Bool {
        if(super.usagesReported(parsedArguments, executor)){
            return true;
        }
        else {
            // TODO: type compatibility checking in set command? (currently a key with a certain type can be replaced by a value of a different type)
            /* final value = getValueArgument(parsedArguments);
            final sharedMemoryForValuesType = getSharedMemoryForValuesType(value);
            final sharedMemoryKey = SharedMemoryGameState.getAPrefixedSharedMemoryKey(
                getGameNameArgument(parsedArguments),
                getStateKeyArgument(parsedArguments).split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR)
            );
            final existingValue = sharedMemoryForValuesType.getValue(sharedMemoryKey);
            final valueToAdd = convertStringValueToMemoryType(value);

            if(!existingValue is Float || !existingValue is String || !valueToAdd is Float || !valueToAdd is String){
                executor.tell('Value $valueToAdd cannot be added to existing value $existingValue');
                return true;
            }
            else  */return false;
        }
    }
}