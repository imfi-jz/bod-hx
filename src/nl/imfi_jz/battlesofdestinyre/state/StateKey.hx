package nl.imfi_jz.battlesofdestinyre.state;

abstract StateKey(Array<String>) from Array<String> to Array<String> {
    public static final STAGE:StateKey = ['Stage'];
    public static final PAUSED:StateKey = ['Paused'];
    public static final SECONDS_PER_TICK:StateKey = ['Seconds per tick'];
    public static final CENTER_X:StateKey = [CENTER, 'X'];
    public static final CENTER_Y:StateKey = [CENTER, 'Y'];
    public static final CENTER_Z:StateKey = [CENTER, 'Z'];
    public static final CENTER_WORLD:StateKey = [CENTER, 'World'];

    // Center section
    private static inline final CENTER = 'Center';

    // Players section
    private static inline final PLAYERS = 'Players';
    private static inline final TEAM = 'Team';
    
    // Stages section
    private static inline final STAGES = 'Stages';
    private static inline final NEXT_STAGE = 'Next stage';
    private static inline final DURATION = 'Duration';
    private static inline final SECONDS_REMAINING = 'Seconds remaining';
    private static inline final MINIMUM_TEAMS = 'Minimum teams';
    private static inline final MAXIMUM_TEAMS = 'Maximum teams';
    private static inline final MINIMUM_PLAYERS_PER_TEAM = 'Minimum players per team';
    private static inline final MAXIMUM_PLAYERS_PER_TEAM = 'Maximum players per team';
    private static inline final ALLOW_PVP = 'Allow PVP';
    private static inline final COMMANDS = 'Commands';
    private static inline final COMMANDS_AT_SECONDS_REMAINING = 'Commands at seconds remaining';

    public inline function toString(delimiter:String):String {
        return this.join(delimiter);
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
    public static inline function stageDuration(stageName:String):StateKey {
        return [STAGES, stageName, DURATION];
    }
    // TODO: implement team rules
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
    public static inline function stageAllowPvp(stageName:String):StateKey {
        return [STAGES, stageName, ALLOW_PVP];
    }
    public static inline function stageCommands(stageName:String):StateKey {
        return [STAGES, stageName, COMMANDS];
    }
    public static inline function stageCommandsAtSecondsRemaining(stageName:String, secondsRemaining:Float):StateKey {
        return [STAGES, stageName, Std.string(Math.floor(secondsRemaining)), COMMANDS_AT_SECONDS_REMAINING];
    }
}