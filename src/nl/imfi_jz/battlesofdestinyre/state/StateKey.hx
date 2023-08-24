package nl.imfi_jz.battlesofdestinyre.state;

// TODO: Maybe refactor so that state key's types can be obtained even if they have variables in them (like player team, and stage duration)
//  and so that keys with variables can be non-custom keys.
abstract StateKey(Array<String>) from Array<String> to Array<String> {
    public static final STAGE:StateKey = ["Stage"];
    public static final PAUSED:StateKey = ["Paused"];
    public static final SECONDS_PER_TICK:StateKey = ["Seconds per tick"];

    private static final PLAYERS = "Players";
    private static final TEAM = "Team";
    
    private static final STAGES = "Stages";
    private static final NEXT_STAGE = "Next stage";
    private static final SECONDS_REMAINING = "Seconds remaining";

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
        ];
    }
    
    public static inline function floatKeys():Array<StateKey> {
        return [
            SECONDS_PER_TICK,
        ];
    }

    public static inline function stringKeys():Array<StateKey> {
        return [
            STAGE,
        ];
    }

    public static inline function stringArrayKeys():Array<StateKey> {
        return [
            
        ];
    }

    public static inline function playerTeam(playerName:String):StateKey {
        return [PLAYERS, playerName, TEAM];
    }

    public static inline function stageNextStage(stageName:String):StateKey {
        return [STAGES, stageName, NEXT_STAGE];
    }

    public static inline function stageSecondsRemaining(stageName:String):StateKey {
        return [STAGES, stageName, SECONDS_REMAINING];
    }
}