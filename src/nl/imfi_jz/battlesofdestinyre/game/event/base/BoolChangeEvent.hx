package nl.imfi_jz.battlesofdestinyre.game.event.base;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;

abstract class BoolChangeEvent extends StateChangeEvent<Bool> {
    
    public function new(
        stateKey:StateKey,
        game
    ) {
        super(game);

        game.getGameStateChangeListener().setBoolChangeHandler(
            stateKey,
            game.getPlugin().getSharedPluginMemory().getBoolMemory(),
            handle
        );
    }
}