package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.battlesofdestinyre.game.event.base.BoolChangeEvent;

class PauseEvent extends BoolChangeEvent {
    private final clock:Clock;

    public function new(game, clock) {
        super(StateKey.PAUSED, game);

        this.clock = clock;
    }

	function handle(wasPaused:Null<Bool>, isPaused:Null<Bool>) {
        Debugger.log('Pause toggled. Paused was: $wasPaused, paused is: $isPaused');

        if(isPaused != null && !isPaused && (wasPaused == null || wasPaused)){
            clock.start();
        }
        
        if(isPaused == null || isPaused){
            clock.stop();
        }
    }
}