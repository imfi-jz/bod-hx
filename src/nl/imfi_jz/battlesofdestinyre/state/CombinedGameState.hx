package nl.imfi_jz.battlesofdestinyre.state;

class CombinedGameState implements GameState {

	public final sharedMemoryKeyPrefix:String;

    private final sharedMemoryGameState:GameState;
    private final fileGameState:GameState;
    
    public function new(sharedMemoryGameState:SharedMemoryGameState, fileGameState:FileGameState) {
        this.sharedMemoryGameState = sharedMemoryGameState;
		this.fileGameState = fileGameState;

		sharedMemoryKeyPrefix = sharedMemoryGameState.sharedMemoryKeyPrefix;
    }

	public function getName():String {
		return fileGameState.getName();
	}

	public function getStage():String {
		return sharedMemoryGameState.getStage();
	}

	public function setStage(stage:String) {
		fileGameState.setStage(stage);
		sharedMemoryGameState.setStage(stage);
	}

	public function getSecondsRemaining():Int {
		return sharedMemoryGameState.getSecondsRemaining();
	}

	public function setSecondsRemaining(secondsRemaining:Int) {
		fileGameState.setSecondsRemaining(secondsRemaining);
		sharedMemoryGameState.setSecondsRemaining(secondsRemaining);
	}

	public function getSecondsBetweenTicks():Int {
		return sharedMemoryGameState.getSecondsBetweenTicks();
	}

	public function setSecondsBetweenTicks(secondsBetweenTicks:Int) {
		fileGameState.setSecondsBetweenTicks(secondsBetweenTicks);
		sharedMemoryGameState.setSecondsBetweenTicks(secondsBetweenTicks);
	}

	public function isPaused():Bool {
		return sharedMemoryGameState.isPaused();
	}

	public function setPaused(paused:Bool) {
		fileGameState.setPaused(paused);
		sharedMemoryGameState.setPaused(paused);
	}
}