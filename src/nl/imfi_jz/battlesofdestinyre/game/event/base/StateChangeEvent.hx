package nl.imfi_jz.battlesofdestinyre.game.event.base;

import nl.imfi_jz.minecraft_api.implementation.Debugger;

abstract class StateChangeEvent<T> {
    private final initializedGame:InitializedGame;

    public function new(initializedGame:InitializedGame) {
        Debugger.log(Type.getClassName(Type.getClass(this)).substring(
            Type.getClassName(Type.getClass(this)).lastIndexOf(".") + 1
        ) + " created");

        this.initializedGame = initializedGame;
    }

    abstract function handle(previousValue:Null<T>, newValue:Null<T>):Void;

    private function getInitializedGame():InitializedGame {
        return initializedGame;
    }
}