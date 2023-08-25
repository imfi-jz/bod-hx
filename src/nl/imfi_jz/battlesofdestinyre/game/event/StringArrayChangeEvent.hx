package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.state.StateKey;

abstract class StringArrayChangeEvent extends StateChangeEvent<Array<String>> {
    
    public function new(
        stateKey:StateKey,
        game
    ) {
        super(game);

        game.getGameStateChangeListener().setStringArrayChangeHandler(
            stateKey,
            game.getPlugin().getSharedPluginMemory().getObjectMemory(),
            handle
        );
    }
}