package nl.imfi_jz.battlesofdestinyre.state.listener;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class GameStateChangeListener {
    private final fileGameState:GameState;
    private final objectMemory:SharedMemory<Dynamic>;

    public function new(fileGameState:FileGameState, objectMemory) {
        this.fileGameState = fileGameState;
        this.objectMemory = objectMemory;
    }

    private function handle<T>(sharedMemory:SharedMemory<T>, key:StateKey, persistFunction:(newValue:T)->Void, handler:(previousValue:T, newValue:T)->Void):Void {
        sharedMemory.valueChanged(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(fileGameState.getName(), key),
            (previousValue, newValue) -> {
                persistFunction(newValue);

                if(handler != null) {
                    handler(previousValue, newValue);
                }
            }
        );

        addKeyToTrackedKeys(key.toString(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
    }

    public function setBoolChangeHandler(key:StateKey, sharedMemory:SharedMemory<Bool>, ?handler:(previousValue:Bool, newValue:Bool)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setBool(key, newValue), handler);
    }

    public function setFloatChangeHandler(key:StateKey, sharedMemory:SharedMemory<Float>, ?handler:(previousValue:Float, newValue:Float)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setFloat(key, newValue), handler);
    }

    public function setStringChangeHandler(key:StateKey, sharedMemory:SharedMemory<String>, ?handler:(previousValue:String, newValue:String)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setString(key, newValue), handler);
    }

    public function setStringArrayChangeHandler(key:StateKey, sharedMemory:SharedMemory<Dynamic>, ?handler:(previousValue:Dynamic, newValue:Dynamic)->Void):Void {
        handle(sharedMemory, key, (newValue) -> fileGameState.setStringArray(key, newValue), handler);
    }

    private function addKeyToTrackedKeys(key:String) {
        final gameTrackedKeysKey = GeneralMemoryKey.TRACKED_KEYS_MEMORY_KEY.concat([fileGameState.getName()]);
        final existingTrackedKeys:Array<String> = getTrackedKeys(objectMemory)
            .map((trackedKey) -> trackedKey.join(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));

        if(!existingTrackedKeys.contains(key)){
            objectMemory.setValue(
                SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey),
                existingTrackedKeys.concat([key])
            );
        }
    }
    
    public function getTrackedKeys(objectMemory:SharedMemory<Dynamic>):Array<Array<String>> {
        final gameTrackedKeysKey = GeneralMemoryKey.TRACKED_KEYS_MEMORY_KEY.concat([fileGameState.getName()]);
        final existingTrackedKeys:Array<String> = objectMemory.getValue(
            SharedMemoryGameState.getAPrefixedSharedMemoryKey(null, gameTrackedKeysKey)
        );

        if(existingTrackedKeys == null){
            return [];
        }
        else return existingTrackedKeys.map((key) -> key.split(SharedMemoryGameState.SHARED_MEMORY_KEY_SEPARATOR));
    }
}