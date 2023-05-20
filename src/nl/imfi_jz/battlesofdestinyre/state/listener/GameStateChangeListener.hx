package nl.imfi_jz.battlesofdestinyre.state.listener;

import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class GameStateChangeListener {
    private final fileGameState:FileGameState;
    private final key:StateKey;

    public function new(fileGameState, key) {
        this.fileGameState = fileGameState;
        this.key = key;
    }

    private function handle<T>(sharedMemory:SharedMemory<T>, persistFunction:(newValue:T)->Void, handler:(newValue:T)->Void):Void {
        sharedMemory.valueChanged(
            SharedMemoryGameState.getSharedMemoryKeyPrefix(fileGameState.getName(), key),
            (previousValue, newValue) -> {
                persistFunction(newValue);

                if(handler != null) {
                    handler(newValue);
                }
            }
        );
    }

    public function setBoolChangeHandler(sharedMemory:SharedMemory<Bool>, ?handler:(newValue:Bool)->Void):Void {
        handle(sharedMemory, (newValue) -> fileGameState.setBool(key, newValue), handler);
    }

    public function setFloatChangeHandler(sharedMemory:SharedMemory<Float>, ?handler:(newValue:Float)->Void):Void {
        handle(sharedMemory, (newValue) -> fileGameState.setFloat(key, newValue), handler);
    }

    public function setStringChangeHandler(sharedMemory:SharedMemory<String>, ?handler:(newValue:String)->Void):Void {
        handle(sharedMemory, (newValue) -> fileGameState.setString(key, newValue), handler);
    }

    public function setStringArrayChangeHandler(sharedMemory:SharedMemory<Dynamic>, ?handler:(newValue:Dynamic)->Void):Void {
        handle(sharedMemory, (newValue) -> fileGameState.setStringArray(key, newValue), handler);
    }
}