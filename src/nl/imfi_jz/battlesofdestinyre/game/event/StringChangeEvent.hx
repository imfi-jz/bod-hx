package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;

abstract class StringChangeEvent extends StateChangeEvent<String> {
    
    public function new(
        stateKey:StateKey,
        game
    ) {
        super(game);

        game.getGameStateChangeListener().setStringChangeHandler(
            stateKey,
            game.getPlugin().getSharedPluginMemory().getStringMemory(),
            handle
        );
    }
}