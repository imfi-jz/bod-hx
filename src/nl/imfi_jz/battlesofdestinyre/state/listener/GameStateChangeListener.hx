package nl.imfi_jz.battlesofdestinyre.state.listener;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class GameStateChangeListener {
    private static final TRACKED_KEYS_MEMORY_KEY = ['keys'];

    private final persistentGameState:GameState;
    private final objectMemory:SharedMemory<Dynamic>;

    public function new(fileGameState, objectMemory) {
        this.persistentGameState = fileGameState;
        this.objectMemory = objectMemory;
    }

    private function handle<T>(sharedMemory:SharedMemory<T>, key:StateKey, persistFunction:(newValue:T)->Void, handler:(previousValue:T, newValue:T)->Void):Void {
        sharedMemory.valueChanged(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(persistentGameState.getName(), key),
            (previousValue, newValue) -> {
                persistFunction(newValue);

                if(handler != null) {
                    handler(previousValue, newValue);
                }
            }
        );

        addKeyToTrackedKeys(key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR), persistentGameState.getName());
    }

    public function setBoolChangeHandler(key:StateKey, sharedMemory:SharedMemory<Bool>, ?handler:(previousValue:Bool, newValue:Bool)->Void):Void {
        handle(sharedMemory, key, (newValue) -> persistentGameState.setBool(key, newValue), handler);
    }

    public function setFloatChangeHandler(key:StateKey, sharedMemory:SharedMemory<Float>, ?handler:(previousValue:Float, newValue:Float)->Void):Void {
        handle(sharedMemory, key, (newValue) -> persistentGameState.setFloat(key, newValue), handler);
    }

    public function setStringChangeHandler(key:StateKey, sharedMemory:SharedMemory<String>, ?handler:(previousValue:String, newValue:String)->Void):Void {
        handle(sharedMemory, key, (newValue) -> persistentGameState.setString(key, newValue), handler);
    }

    public function setStringArrayChangeHandler(key:StateKey, sharedMemory:SharedMemory<Dynamic>, ?handler:(previousValue:Dynamic, newValue:Dynamic)->Void):Void {
        handle(sharedMemory, key, (newValue) -> persistentGameState.setStringArray(key, newValue), handler);
    }

    private function addKeyToTrackedKeys(key:String, gameName:String) {
        final gameTrackedKeysKey = TRACKED_KEYS_MEMORY_KEY.concat([gameName]);
        final existingTrackedKeys:Array<String> = objectMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey)
        );

        if(existingTrackedKeys == null){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey),
                [key]
            );
        }
        else if(!existingTrackedKeys.contains(key)){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey),
                existingTrackedKeys.concat([key])
            );
        }
    }
}