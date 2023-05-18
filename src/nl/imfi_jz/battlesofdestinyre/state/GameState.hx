package nl.imfi_jz.battlesofdestinyre.state;

interface GameState {
    function getName():String;

    function getStage():String;
    function setStage(stage:String):Void;

    function getSecondsRemaining():Int;
    function setSecondsRemaining(secondsRemaining:Int):Void;

    function getSecondsBetweenTicks():Int;
    function setSecondsBetweenTicks(secondsBetweenTicks:Int):Void;

    function isPaused():Bool;
    function setPaused(paused:Bool):Void;
}