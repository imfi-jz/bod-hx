package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;

abstract class FloatChangeEvent extends StateChangeEvent<Float> {
    
    public function new(
        stateKey:StateKey,
        game
    ) {
        super(game);

        game.getGameStateChangeListener().setFloatChangeHandler(
            stateKey,
            game.getPlugin().getSharedPluginMemory().getFloatMemory(),
            handle
        );
    }
}