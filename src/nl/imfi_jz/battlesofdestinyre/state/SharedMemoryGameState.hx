package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class SharedMemoryGameState implements GameState {

    private static inline final SHARED_MEMORY_PREFIX = 'bod';
	public static inline final SHARED_MEMORY_KEY_SEPARATOR:String = '.';
	
	public final sharedMemoryKeyPrefix:String;

	private final stringMemory:SharedMemory<String>;
	private final floatMemory:SharedMemory<Float>;
	private final boolMemory:SharedMemory<Bool>;
	private final objectMemory:SharedMemory<Dynamic>;
	private final stateName:String;
    
    public function new(stateName, sharedMemory:SharedPluginMemory, pluginNameCapitals:String) {
		this.stateName = stateName;
		this.sharedMemoryKeyPrefix = pluginNameCapitals.toLowerCase() + SHARED_MEMORY_KEY_SEPARATOR + stateName + SHARED_MEMORY_KEY_SEPARATOR;
		stringMemory = sharedMemory.getStringMemory();
		floatMemory = sharedMemory.getFloatMemory();
		boolMemory = sharedMemory.getBoolMemory();
		objectMemory = sharedMemory.getObjectMemory();
    }

	// TODO: Split into two functions. One with, one without stateName where the one without stateName should not be static?
	public static function getSharedMemoryKeyPrefix(?stateName:String, key:Array<String>):String {
		if(stateName == null){
			return SHARED_MEMORY_PREFIX + SHARED_MEMORY_KEY_SEPARATOR + key.join(SHARED_MEMORY_KEY_SEPARATOR);
		}
		else return SHARED_MEMORY_PREFIX + SHARED_MEMORY_KEY_SEPARATOR + stateName + SHARED_MEMORY_KEY_SEPARATOR + key.join(SHARED_MEMORY_KEY_SEPARATOR);
	}

	public function getName():String {
		return stateName;
	}

	@:deprecated
    public function initializeBoolFromFileState(key:String, fileGameState:FileGameState):Void {
		final existingValue = fileGameState.getBool(key.split(SHARED_MEMORY_KEY_SEPARATOR));

		boolMemory.setValue(sharedMemoryKeyPrefix + key, existingValue);

		/* boolMemory.valueChanged(sharedMemoryKeyPrefix + key, (previousValue, newValue) -> {
			fileGameState.setBool(key.split(SHARED_MEMORY_KEY_SEPARATOR), newValue);
		}); */
	}

    public function trackFloat(key:String, fileGameState:FileGameState):Void {
		final existingValue = fileGameState.getFloat(key.split(SHARED_MEMORY_KEY_SEPARATOR));

		floatMemory.setValue(sharedMemoryKeyPrefix + key, existingValue);

		floatMemory.valueChanged(sharedMemoryKeyPrefix + key, (previousValue, newValue) -> {
			fileGameState.setFloat(key.split(SHARED_MEMORY_KEY_SEPARATOR), newValue);
		});
	}

    public function trackString(key:String, fileGameState:FileGameState):Void {
		final existingValue = fileGameState.getString(key.split(SHARED_MEMORY_KEY_SEPARATOR));

		stringMemory.setValue(sharedMemoryKeyPrefix + key, existingValue);

		stringMemory.valueChanged(sharedMemoryKeyPrefix + key, (previousValue, newValue) -> {
			fileGameState.setString(key.split(SHARED_MEMORY_KEY_SEPARATOR), newValue);
		});
	}

    public function trackStringArray(key:String, fileGameState:FileGameState):Void {
		final existingValue = fileGameState.getStringArray(key.split(SHARED_MEMORY_KEY_SEPARATOR));

		objectMemory.setValue(sharedMemoryKeyPrefix + key, existingValue);

		objectMemory.valueChanged(sharedMemoryKeyPrefix + key, (previousValue, newValue) -> {
			fileGameState.setStringArray(key.split(SHARED_MEMORY_KEY_SEPARATOR), newValue);
		});
	}

	public function getString(key:Array<String>):String {
		return stringMemory.getValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR));
	}

	public function setString(key:Array<String>, value:String) {
		stringMemory.setValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR), value);
	}

	public function getFloat(key:Array<String>):Float {
		return floatMemory.getValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR));
	}

	public function setFloat(key:Array<String>, value:Float) {
		floatMemory.setValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR), value);
	}

	public function getBool(key:Array<String>):Bool {
		return boolMemory.getValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR));
	}

	public function setBool(key:Array<String>, value:Bool) {
		boolMemory.setValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR), value);
	}

	public function getStringArray(key:Array<String>):Array<String> {
		return objectMemory.getValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR));
	}

	public function setStringArray(key:Array<String>, value:Array<String>) {
		objectMemory.setValue(sharedMemoryKeyPrefix + key.join(SHARED_MEMORY_KEY_SEPARATOR), value);
	}
}