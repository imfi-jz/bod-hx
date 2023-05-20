package nl.imfi_jz.battlesofdestinyre.state;

abstract StateKey(Array<String>) from Array<String> to Array<String> {
    public static final STAGE:StateKey = ["Stage"];
    public static final SECONDS_REMAINING:StateKey = ["Seconds remaining"];
    public static final PAUSED:StateKey = ["Paused"];
    public static final SECONDS_BETWEEN_TICKS:StateKey = ["Seconds between ticks"];

    public inline function toString(delimiter:String):String {
        return this.join(delimiter);
    }

    public static inline function allKeys():Array<StateKey> {
        return boolKeys().concat(intKeys()).concat(stringKeys());
    }

    public static inline function boolKeys():Array<StateKey> {
        return [
            PAUSED,
        ];
    }
    
    public static inline function intKeys():Array<StateKey> {
        return [
            SECONDS_REMAINING,
            SECONDS_BETWEEN_TICKS
        ];
    }
    
    public static inline function floatKeys():Array<StateKey> {
        return [
            
        ];
    }

    public static inline function stringKeys():Array<StateKey> {
        return [
            STAGE
        ];
    }

    public static inline function stringArrayKeys():Array<StateKey> {
        return [
            
        ];
    }
}