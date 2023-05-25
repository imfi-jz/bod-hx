package nl.imfi_jz.battlesofdestinyre.game.event;

abstract class StateChangeEvent<T> {
    abstract function handle(previousValue:T, newValue:T):Void;
}