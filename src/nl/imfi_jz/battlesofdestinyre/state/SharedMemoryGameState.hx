package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;

class SharedMemoryGameState implements GameState {

	private static inline final SHARED_MEMORY_KEY_SEPARATOR:String = '.';
	
	public final sharedMemoryKeyPrefix:String;

	private final stringMemory:SharedMemory<String>;
	private final floatMemory:SharedMemory<Float>;
	private final boolMemory:SharedMemory<Bool>;
	private final pluginNameCapitalsLower:String;
	private final stateName:String;
    
    public function new(stateName, sharedMemory:SharedPluginMemory, pluginNameCapitals) {
		this.pluginNameCapitalsLower = pluginNameCapitals.toLowerCase();
		this.stateName = stateName;
		this.sharedMemoryKeyPrefix = pluginNameCapitalsLower + SHARED_MEMORY_KEY_SEPARATOR + stateName + SHARED_MEMORY_KEY_SEPARATOR;
		stringMemory = sharedMemory.getStringMemory();
		floatMemory = sharedMemory.getFloatMemory();
		boolMemory = sharedMemory.getBoolMemory();
    }

	public function getName():String {
		return stateName;
	}

	public function getStage():String {
		return stringMemory.getValue(sharedMemoryKeyPrefix + StateKey.STAGE);
	}

	public function setStage(stage:String) {
        stringMemory.setValue(sharedMemoryKeyPrefix + StateKey.STAGE, stage);
    }

	public function getSecondsRemaining():Int {
		return cast floatMemory.getValue(sharedMemoryKeyPrefix + StateKey.SECONDS_REMAINING);
	}

	public function setSecondsRemaining(secondsRemaining:Int) {
		floatMemory.setValue(sharedMemoryKeyPrefix + StateKey.SECONDS_REMAINING, secondsRemaining);
    }

	public function getSecondsBetweenTicks():Int {
		return cast floatMemory.getValue(sharedMemoryKeyPrefix + StateKey.SECONDS_BETWEEN_TICKS);
	}

	public function setSecondsBetweenTicks(secondsBetweenTicks:Int) {
		floatMemory.setValue(sharedMemoryKeyPrefix + StateKey.SECONDS_BETWEEN_TICKS, secondsBetweenTicks);
	}

	public function isPaused():Bool {
		return boolMemory.getValue(sharedMemoryKeyPrefix + StateKey.PAUSED);
	}

	public function setPaused(paused:Bool) {
		boolMemory.setValue(sharedMemoryKeyPrefix + StateKey.PAUSED, paused);
	}
}