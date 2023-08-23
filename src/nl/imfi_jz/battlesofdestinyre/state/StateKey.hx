package nl.imfi_jz.battlesofdestinyre.state;

// TODO: Maybe refactor so that state key's types can be obtained even if they have variables in them (like player team, and stage duration)
//  and so that keys with variables can be non-custom keys.
abstract StateKey(Array<String>) from Array<String> to Array<String> {
    //public static final GAME_MODE:StateKey = ["Gamemode"];
    public static final STAGE:StateKey = ["Stage"];
    public static final SECONDS_REMAINING:StateKey = ["Seconds remaining"]; // TODO: move to sub stage key
    public static final PAUSED:StateKey = ["Paused"];
    public static final SECONDS_BETWEEN_TICKS:StateKey = ["Seconds between ticks"];
    //public static final ALLOW_JOINS:StateKey = ["Allow joins"];

    public inline function toString(delimiter:String):String {
        return this.join(delimiter);
    }

    public static inline function allKeys():Array<StateKey> {
        return boolKeys()
            .concat(stringKeys())
            .concat(stringArrayKeys())
            .concat(floatKeys());
    }

    public static inline function boolKeys():Array<StateKey> {
        return [
            PAUSED,
           //ALLOW_JOINS,
        ];
    }
    
    public static inline function floatKeys():Array<StateKey> {
        return [
            SECONDS_REMAINING,
            SECONDS_BETWEEN_TICKS,
        ];
    }

    public static inline function stringKeys():Array<StateKey> {
        return [
            //GAME_MODE,
            STAGE,
        ];
    }

    public static inline function stringArrayKeys():Array<StateKey> {
        return [
            
        ];
    }

    public static inline function playerTeam(playerName:String):StateKey {
        return ["Player", playerName, "Team"];
    }

    public static inline function stageNextStage(stageName:String):StateKey {
        return [STAGE.toString(''), stageName, "Next stage"];
    }

    public static inline function stageSecondsRemaining(stageName:String):StateKey {
        return [STAGE.toString(''), stageName, SECONDS_REMAINING.toString('')];
    }
}