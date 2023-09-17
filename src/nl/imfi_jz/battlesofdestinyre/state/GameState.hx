package nl.imfi_jz.battlesofdestinyre.state;

interface GameState {
    function getName():String;

    function getString(key:StateKey):Null<String>;
    function setString(key:StateKey, value:Null<String>):Void;
    
    function getFloat(key:StateKey):Null<Float>;
    function setFloat(key:StateKey, value:Null<Float>):Void;

    function getBool(key:StateKey):Null<Bool>;
    function setBool(key:StateKey, value:Null<Bool>):Void;

    function getStringArray(key:StateKey):Null<Array<String>>;
    function setStringArray(key:StateKey, value:Null<Array<String>>):Void;
}