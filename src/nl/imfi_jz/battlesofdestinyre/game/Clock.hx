package nl.imfi_jz.battlesofdestinyre.game;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.game.event.TickEvent;
import nl.imfi_jz.minecraft_api.implementation.Debugger;

class Clock {
    private final game:InitializedGame;
    private final stageName:String;
    
    public function new(game, stageName) {
        this.game = game;
        this.stageName = stageName;
    }

    public function start() {
        Debugger.log("Starting " + game.getName() + "'s clock in stage " + stageName);

        if(stageName == null){
            Debugger.warn("Stage name is null, not starting clock");
        }
        else {
            new TickEvent(game, this, stageName);

            final currentSecondsRemaining = game.getMemoryGameState().getFloat(StateKey.stageSecondsRemaining(stageName));
            final secondsPerTick = game.getMemoryGameState().getFloat(StateKey.SECONDS_PER_TICK);
            scheduleNextTick(currentSecondsRemaining, secondsPerTick);
        }
    }

    public function stop() {
        Debugger.log("Stopping " + game.getName() + "'s clock in stage " + stageName);
        
        new UnhandledTickEvent(game, stageName);
    }

    public function scheduleNextTick(currentSecondsRemaining:Null<Float>, secondsPerTick:Null<Float>) {
        if(secondsPerTick == null || secondsPerTick == 0){
            Debugger.warn(Std.string(StateKey.SECONDS_PER_TICK) + ' is $secondsPerTick, can\'t schedule next tick');
        }
        else game.getPlugin().getScheduler().executeAfterSeconds(
            secondsPerTick < 0 ? -secondsPerTick : secondsPerTick,
            () -> {
                game.getMemoryGameState().setFloat(
                    StateKey.stageSecondsRemaining(stageName),
                    currentSecondsRemaining == null
                        ? game.getMemoryGameState().getFloat(StateKey.stageDurationInSeconds(stageName))
                        : currentSecondsRemaining - secondsPerTick
                );
            }
        );
    }
}