package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;

abstract class StateChangeEvent<T> {
    public function new() {
        Debugger.log(Type.getClassName(Type.getClass(this)) + " created");
    }

    abstract function handle(previousValue:Null<T>, newValue:Null<T>):Void;
}