package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.KeyValueFile.NestableKeyValueFile;

class FileGameState implements GameState {
    private final file:NestableKeyValueFile<Any>;

    public function new(file) {
        this.file = file;
    }

	public function getName():String {
		final fileName = file.getName();
		Debugger.log('Actual file name: $fileName');
		return fileName.substring(0, fileName.lastIndexOf('.'));
	}

	public function getStage():String {
		return file.getValue(StateKey.STAGE);
	}

	public function setStage(stage:String) {
		file.setValue(StateKey.STAGE, stage);
	}

	public function getSecondsRemaining():Int {
		return file.getValue(StateKey.SECONDS_REMAINING);
	}

	public function setSecondsRemaining(secondsRemaining:Int) {
		file.setValue(StateKey.SECONDS_REMAINING, secondsRemaining);
	}

	public function getSecondsBetweenTicks():Int {
		return file.getValue(StateKey.SECONDS_BETWEEN_TICKS);
	}

	public function setSecondsBetweenTicks(secondsBetweenTicks:Int) {
		file.setValue(StateKey.SECONDS_BETWEEN_TICKS, secondsBetweenTicks);
	}

	public function isPaused():Bool {
		return file.getValue(StateKey.PAUSED);
	}

	public function setPaused(paused:Bool) {
		file.setValue(StateKey.PAUSED, paused);
	}
}