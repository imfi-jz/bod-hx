package nl.imfi_jz.battlesofdestinyre.state.listener;

import java.lang.IllegalArgumentException;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class GameStateChangeListener {
    private final fileGameState:GameState;
    private final objectMemory:SharedMemory<Dynamic>;

    public function new(fileGameState:FileGameState, objectMemory) {
        this.fileGameState = fileGameState;
        this.objectMemory = objectMemory;
    }

    private function handle<T>(sharedMemory:SharedMemory<T>, key:StateKey, persistFunction:(newValue:Null<T>)->Void, handler:(previousValue:Null<T>, newValue:Null<T>)->Void):Void {
        sharedMemory.valueChanged(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(fileGameState.getName(), key),
            (previousValue, newValue) -> {
                persistFunction(newValue);

                if(newValue == null){
                    removeKeyFromTrackedKeys(key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
                    sharedMemory.valueChanged(SharedMemoryGameState.getAPrefixedSharedMemoryKey(fileGameState.getName(), key), null);
                }
                else if(handler != null) {
                    handler(previousValue, newValue);
                }
            }
        );

        addKeyToTrackedKeys(key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
    }

    public function setBoolChangeHandler(key:StateKey, sharedMemory:SharedMemory<Bool>, ?handler:(previousValue:Null<Bool>, newValue:Null<Bool>)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setBool(key, newValue), handler);
    }

    public function setFloatChangeHandler(key:StateKey, sharedMemory:SharedMemory<Float>, ?handler:(previousValue:Null<Float>, newValue:Null<Float>)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setFloat(key, newValue), handler);
    }

    public function setStringChangeHandler(key:StateKey, sharedMemory:SharedMemory<String>, ?handler:(previousValue:String, newValue:String)->Void):Void {
        handle(
            sharedMemory,
            key,
            (newValue) -> {
                if(newValue == null || Math.isNaN(Std.parseFloat(newValue))){ // TODO: Maybe move the 'isNumber' check to a seperate function
                    fileGameState.setString(key, newValue);
                }
                else throw new IllegalArgumentException('$newValue cannot be set to a string key as it would be parsed as a number');
            },
            handler
        );
    }

    public function setStringArrayChangeHandler(key:StateKey, sharedMemory:SharedMemory<Dynamic>, ?handler:(previousValue:Dynamic, newValue:Dynamic)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setStringArray(key, newValue), handler);
    }

    private function addKeyToTrackedKeys(key:String) {
        final gameTrackedKeysKey = GeneralMemoryKey.getTrackedKeysMemoryKey(fileGameState.getName());
        final existingTrackedKeys:Array<String> = getTrackedKeys(objectMemory)
            .map((trackedKey) -> trackedKey.join(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));

        if(!existingTrackedKeys.contains(key)){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey),
                existingTrackedKeys.concat([key])
            );
        }
    }

    private function removeKeyFromTrackedKeys(key:String) {
        final gameTrackedKeysKey = GeneralMemoryKey.getTrackedKeysMemoryKey(fileGameState.getName());
        final existingTrackedKeys:Array<String> = getTrackedKeys(objectMemory)
            .map((trackedKey) -> trackedKey.join(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));

        if(existingTrackedKeys.contains(key)){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey),
                existingTrackedKeys.filter((trackedKey) -> trackedKey != key)
            );
        }
    }
    
    /** Returns all keys that are tracked for this game where the outer array are the keys and the inner array are the parts of the key (as seperated by the delimiter) **/
    public function getTrackedKeys(objectMemory:SharedMemory<Dynamic>):Array<Array<String>> {
        final gameTrackedKeysKey = GeneralMemoryKey.getTrackedKeysMemoryKey(fileGameState.getName());
        final existingTrackedKeys:Array<String> = objectMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey)
        );

        if(existingTrackedKeys == null){
            return [];
        }
        else return existingTrackedKeys.map((key) -> key.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
    }
}