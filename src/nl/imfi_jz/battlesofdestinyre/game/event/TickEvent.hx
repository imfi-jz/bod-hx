package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.game.event.base.FloatChangeEvent;

class TickEvent extends FloatChangeEvent {
    private final clock:Clock;
    private final stageName:String;

    public function new(game, clock, stageName) {
        super(StateKey.stageSecondsRemaining(stageName), game);
        
        this.clock = clock;
        this.stageName = stageName;
    }
    
	private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        // Maybe add a check if the game is paused before proceeding so the game won't execute a tick after the game is paused
        Debugger.log("Ticking");

        if(currentSecondsRemaining == null || currentSecondsRemaining > 0){
            final secondsPerTick = getInitializedGame().getMemoryGameState().getFloat(StateKey.SECONDS_PER_TICK);
            if(secondsPerTick != null){
                final stageDurationInSeconds = getInitializedGame().getMemoryGameState().getFloat(StateKey.stageDurationInSeconds(stageName));
                clock.scheduleNextTick(currentSecondsRemaining ?? stageDurationInSeconds, secondsPerTick);

                if(currentSecondsRemaining != null){
                    executeCommandsAtSecondsRemaining(currentSecondsRemaining, secondsPerTick);

                    if(stageDurationInSeconds != null){
                        handleTeamConstraints(currentSecondsRemaining, secondsPerTick, stageDurationInSeconds);
                    }
                }
            }
        }
        else if(currentSecondsRemaining != null && currentSecondsRemaining <= 0){
            Debugger.log("Stage time is up. Should switch stage");
            switchToNextStage();
        }
    }

    private function handleTeamConstraints(currentSecondsRemaining:Float, secondsPerTick:Float, stageDurationInSeconds:Float) {
        final minTeams = getInitializedGame().getMemoryGameState().getFloat(StateKey.stageMinimumTeams(stageName)) ?? 0.;
        final maxTeams = getInitializedGame().getMemoryGameState().getFloat(StateKey.stageMaximumTeams(stageName)) ?? 99999.;
        final teams = getInitializedGame().getTeams();

        final handleConstraintsNotMet = () -> {
            // Flip seconds per tick to prevent the game from progressing
            if((currentSecondsRemaining < stageDurationInSeconds && secondsPerTick > 0)
                || (currentSecondsRemaining >= stageDurationInSeconds && secondsPerTick < 0)){
                getInitializedGame().getMemoryGameState().setFloat(StateKey.SECONDS_PER_TICK, -secondsPerTick);
            }
        }

        if(teams.length < minTeams){
            Debugger.log('Not enough teams');
            handleConstraintsNotMet();
        }
        else if(teams.length > maxTeams){
            Debugger.log('Too many teams');
            handleConstraintsNotMet();
        }
        else {
            final minPlayersPerTeam = getInitializedGame().getMemoryGameState().getFloat(StateKey.stageMinimumPlayersPerTeam(stageName)) ?? 0.;
            final maxPlayersPerTeam = getInitializedGame().getMemoryGameState().getFloat(StateKey.stageMaximumPlayersPerTeam(stageName)) ?? 99999.;

            final leastPlayersInTeam = teams.reduce(99999., (leastPlayersInTeam, team) -> Math.min(leastPlayersInTeam, team.getOnlinePlayers().length));
            final mostPlayersInTeam = teams.reduce(0., (mostPlayersInTeam, team) -> Math.max(mostPlayersInTeam, team.getOnlinePlayers().length));

            if(leastPlayersInTeam < minPlayersPerTeam){
                Debugger.log('Not enough players in a team');
                handleConstraintsNotMet();
            }
            else if(mostPlayersInTeam > maxPlayersPerTeam){
                Debugger.log('Too many players in a team');
                handleConstraintsNotMet();
            }
            else {
                // Conditions met
                Debugger.log('Team conditions met');
                if(secondsPerTick < 0){
                    getInitializedGame().getMemoryGameState().setFloat(StateKey.SECONDS_PER_TICK, -secondsPerTick);
                }
            }
        }
    }

    private function executeCommandsAtSecondsRemaining(currentSecondsRemaining:Float, secondsPerTick:Float) {
        final secondsBetweenTick:Multitude<Int> = [for (s in Math.floor(currentSecondsRemaining)...Math.floor(currentSecondsRemaining + secondsPerTick)) s];
        secondsBetweenTick.each(seconds -> {
            Debugger.log('Checking for commands to execute at second $seconds');
            getInitializedGame().getCommandExecutor().executeUnparsedCommands(
                getInitializedGame().getMemoryGameState().getStringArray(StateKey.stageCommandsAtSecondsRemaining(stageName, seconds))
            );
        });
    }

    private function switchToNextStage() {
        final initializedGame = getInitializedGame();
        final nextStage = initializedGame.getMemoryGameState().getString(StateKey.stageNextStage(stageName));

        clock.stop();

        if(nextStage == null){
            Debugger.log("No next stage found. Game is over");
            /* TODO:
            - mark game as finished?
            - unregister events bound to this game?
            - remove game name from players' tags
            - remove players' team via command
            */

            initializedGame.getOnlinePlayers().each(player -> {
                initializedGame.getPlayerStateStorage().restorePlayerState(player, initializedGame.getPlugin().getGame());
            });
        }
        else {
            initializedGame.getMemoryGameState().setString(StateKey.STAGE, nextStage);
        }
    }
}

class UnhandledTickEvent extends TickEvent {
    public function new(eventData, stageName) {
        super(eventData, null, stageName);
    }
    
    override private function handle(previousSecondsRemaining:Null<Float>, currentSecondsRemaining:Null<Float>) {
        Debugger.log("Unhandled tick");
    }
}