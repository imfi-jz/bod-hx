package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.state.SharedMemoryGameState;
import nl.imfi_jz.battlesofdestinyre.state.listener.GameStateChangeListener;
import nl.imfi_jz.battlesofdestinyre.state.FileGameState;

class InitializedGame {
    private final gameName:String;
    private final fileGameState:FileGameState;
    private final memoryGameState:SharedMemoryGameState;
    private final gameStateChangeListener:GameStateChangeListener;
    
    public function new(gameName, fileGameState, memoryGameState, gameStateChangeListener) {
        this.gameName = gameName;
        this.fileGameState = fileGameState;
        this.memoryGameState = memoryGameState;
        this.gameStateChangeListener = gameStateChangeListener;
    }

    public function getName():String {
        return gameName;
    }

    public function getFileGameState():FileGameState {
        return fileGameState;
    }

    public function getGameStateChangeListener():GameStateChangeListener {
        return gameStateChangeListener;
    }

    public function getMemoryGameState():SharedMemoryGameState {
        return memoryGameState;
    }
}