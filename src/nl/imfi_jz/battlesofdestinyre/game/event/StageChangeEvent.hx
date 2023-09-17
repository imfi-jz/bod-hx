package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.game.event.base.StringChangeEvent;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class StageChangeEvent extends StringChangeEvent {
    public function new(game) {
        super(StateKey.STAGE, game);
    }

	function handle(previousValue:Null<String>, newValue:Null<String>) {
        if(newValue != null){
            final game = getInitializedGame();
            final clock = new Clock(
                game,
                newValue
            );

            new PauseEvent(game, clock);

            if (!game.getMemoryGameState().getBool(StateKey.PAUSED)) {
                clock.start();
            }

            executeStageCommands(newValue);
        }
    }

    private function executeStageCommands(stageName:String) {
        getInitializedGame().getCommandExecutor().executeUnparsedCommands(
            getInitializedGame().getMemoryGameState().getStringArray(StateKey.stageCommands(stageName))
        );
    }
}