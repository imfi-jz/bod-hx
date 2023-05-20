package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class SharedMemoryGameState implements GameState {

    private static inline final SHARED_MEMORY_KEY_PREFIX = 'bod';
    private static inline final SHARED_MEMORY_GAME_KEY_PREFIX = 'game';
	public static inline final SHARED_MEMORY_KEY_SEPARATOR:String = '.';

	private final stringMemory:SharedMemory<String>;
	private final floatMemory:SharedMemory<Float>;
	private final boolMemory:SharedMemory<Bool>;
	private final objectMemory:SharedMemory<Dynamic>;
	private final stateName:String;
    
    public function new(stateName, sharedMemory:SharedPluginMemory) {
		this.stateName = stateName;
		stringMemory = sharedMemory.getStringMemory();
		floatMemory = sharedMemory.getFloatMemory();
		boolMemory = sharedMemory.getBoolMemory();
		objectMemory = sharedMemory.getObjectMemory();
    }

	public static function getAPrefixedSharedMemoryKey(?stateName:String, key:Array<String>):String {
		if(stateName == null){
			return SHARED_MEMORY_KEY_PREFIX + SHARED_MEMORY_KEY_SEPARATOR + key.join(SHARED_MEMORY_KEY_SEPARATOR);
		}
		else return SHARED_MEMORY_KEY_PREFIX
			+ SHARED_MEMORY_KEY_SEPARATOR
			+ SHARED_MEMORY_GAME_KEY_PREFIX
			+ SHARED_MEMORY_KEY_SEPARATOR
			+ stateName
			+ SHARED_MEMORY_KEY_SEPARATOR
			+ key.join(SHARED_MEMORY_KEY_SEPARATOR);
	}

	public function getPrefixedSharedMemoryKey(key:Array<String>):String {
		return getAPrefixedSharedMemoryKey(stateName, key);
	}

	public function getName():String {
		return stateName;
	}

	public function getString(key:StateKey):String {
		return stringMemory.getValue(getPrefixedSharedMemoryKey(key));
	}

	public function setString(key:StateKey, value:String) {
		stringMemory.setValue(getPrefixedSharedMemoryKey(key), value);
	}

	public function getFloat(key:StateKey):Float {
		return floatMemory.getValue(getPrefixedSharedMemoryKey(key));
	}

	public function setFloat(key:StateKey, value:Float) {
		floatMemory.setValue(getPrefixedSharedMemoryKey(key), value);
	}

	public function getBool(key:StateKey):Bool {
		return boolMemory.getValue(getPrefixedSharedMemoryKey(key));
	}

	public function setBool(key:StateKey, value:Bool) {
		boolMemory.setValue(getPrefixedSharedMemoryKey(key), value);
	}

	public function getStringArray(key:StateKey):Array<String> {
		return objectMemory.getValue(getPrefixedSharedMemoryKey(key));
	}

	public function setStringArray(key:StateKey, value:Array<String>) {
		objectMemory.setValue(getPrefixedSharedMemoryKey(key), value);
	}
}