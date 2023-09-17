package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.battlesofdestinyre.game.event.base.StringChangeEvent;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;

class StageChangeEvent extends StringChangeEvent {
    public function new(game) {
        super(StateKey.STAGE, game);
    }

	function handle(previousValue:Null<String>, newValue:Null<String>) {
        if(newValue != null){
            handlePlayerStateStorage(newValue);
            
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

    private function handlePlayerStateStorage(stageName:String) {
        final initializedGame = getInitializedGame();
        final storePlayerStates = initializedGame.getMemoryGameState().getBool(StateKey.stageTempPlayerState(stageName));

        if(storePlayerStates != null){
            final game = initializedGame.getPlugin().getGame();
            if(storePlayerStates){
                initializedGame.getOnlinePlayers().each(player -> {
                    if(!initializedGame.getPlayerStateStorage().containsPlayerState(player)){
                        initializedGame.getPlayerStateStorage().storePlayerState(player, game);
                    }
                });
            }
            else {
                initializedGame.getOnlinePlayers().each(player -> {
                    if(initializedGame.getPlayerStateStorage().containsPlayerState(player)){
                        initializedGame.getPlayerStateStorage().restorePlayerState(player, game);
                    }
                });
            }
        }
    }
}