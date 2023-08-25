package nl.imfi_jz.battlesofdestinyre.state;

// TODO: Maybe refactor so that state key's types can be obtained even if they have variables in them (like player team, and stage duration)
//  and so that keys with variables can be non-custom keys.
abstract StateKey(Array<String>) from Array<String> to Array<String> {
    public static final STAGE:StateKey = ["Stage"];
    public static final PAUSED:StateKey = ["Paused"];
    public static final SECONDS_PER_TICK:StateKey = ["Seconds per tick"];
    public static final CENTER_X:StateKey = [CENTER, "X"];
    public static final CENTER_Y:StateKey = [CENTER, "Y"];
    public static final CENTER_Z:StateKey = [CENTER, "Z"];
    public static final CENTER_WORLD:StateKey = [CENTER, "World"];

    private static inline final CENTER = "Center";

    private static inline final PLAYERS = "Players";
    private static inline final TEAM = "Team";
    
    private static inline final STAGES = "Stages";
    private static inline final NEXT_STAGE = "Next stage";
    private static inline final SECONDS_REMAINING = "Seconds remaining";
    private static inline final MINIMUM_TEAMS = "Minimum teams";
    private static inline final MAXIMUM_TEAMS = "Maximum teams";
    private static inline final MINIMUM_PLAYERS_PER_TEAM = "Minimum players per team";
    private static inline final MAXIMUM_PLAYERS_PER_TEAM = "Maximum players per team";
    private static inline final SECONDS_REMAINING_WHEN_TEAM_CONDITIONS_MET = "Seconds remaining when team conditions met";
    private static inline final TELEPORT_PLAYERS_TO_CENTER = "Teleport players to center";

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
    public static inline function stageMinimumTeams(stageName:String):StateKey {
        return [STAGES, stageName, MINIMUM_TEAMS];
    }
    public static inline function stageMaximumTeams(stageName:String):StateKey {
        return [STAGES, stageName, MAXIMUM_TEAMS];
    }
    public static inline function stageMinimumPlayersPerTeam(stageName:String):StateKey {
        return [STAGES, stageName, MINIMUM_PLAYERS_PER_TEAM];
    }
    public static inline function stageMaximumPlayersPerTeam(stageName:String):StateKey {
        return [STAGES, stageName, MAXIMUM_PLAYERS_PER_TEAM];
    }
    public static inline function stageSecondsRemainingWhenTeamConditionsMet(stageName:String):StateKey {
        return [STAGES, stageName, SECONDS_REMAINING_WHEN_TEAM_CONDITIONS_MET];
    }
    public static inline function stageTeleportPlayersToCenter(stageName:String):StateKey {
        return [STAGES, stageName, TELEPORT_PLAYERS_TO_CENTER];
    }
}