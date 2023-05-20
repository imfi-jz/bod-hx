package nl.imfi_jz.battlesofdestinyre.state;

interface GameState {
    function getName():String;

    /* function getStage():String;
    function setStage(stage:String):Void;

    function getSecondsRemaining():Int;
    function setSecondsRemaining(secondsRemaining:Int):Void;

    function getSecondsBetweenTicks():Int;
    function setSecondsBetweenTicks(secondsBetweenTicks:Int):Void;

    function isPaused():Bool;
    function setPaused(paused:Bool):Void; */

    function getString(key:Array<String>):String;
    function setString(key:Array<String>, value:String):Void;
    
    function getFloat(key:Array<String>):Float;
    function setFloat(key:Array<String>, value:Float):Void;

    function getBool(key:Array<String>):Bool;
    function setBool(key:Array<String>, value:Bool):Void;

    function getStringArray(key:Array<String>):Array<String>;
    function setStringArray(key:Array<String>, value:Array<String>):Void;
}