package nl.imfi_jz.battlesofdestinyre.state.listener;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class GameStateChangeListener {
    private final persistentGameState:GameState;

    public function new(persistentGameState) {
        this.persistentGameState = persistentGameState;
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
}