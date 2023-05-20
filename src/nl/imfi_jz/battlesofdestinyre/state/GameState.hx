package nl.imfi_jz.battlesofdestinyre.state;

interface GameState {
    function getName():String;

    function getString(key:StateKey):String;
    function setString(key:StateKey, value:String):Void;
    
    function getFloat(key:StateKey):Float;
    function setFloat(key:StateKey, value:Float):Void;

    function getBool(key:StateKey):Bool;
    function setBool(key:StateKey, value:Bool):Void;

    function getStringArray(key:StateKey):Array<String>;
    function setStringArray(key:StateKey, value:Array<String>):Void;
}