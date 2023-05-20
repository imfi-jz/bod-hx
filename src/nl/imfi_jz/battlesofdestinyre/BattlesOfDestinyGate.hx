package nl.imfi_jz.battlesofdestinyre;

import nl.imfi_jz.battlesofdestinyre.state.GameStateFactory;
import nl.imfi_jz.battlesofdestinyre.state.StateKey;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Gate;

@:keep
class BattlesOfDestinyGate implements Gate {

	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());

        Debugger.log("Debugger enabled");

        final gameLoader = new GameLoader();
        final exitingGames = gameLoader.getExistingGamesAsFileState(plugin);

        if(exitingGames.any()){
            Debugger.log("Initializing existing games");
            exitingGames.each((state) -> gameLoader.initializeGame(state, plugin));
        }
        else {
            Debugger.log("Creating and initializing test games");
            final generateGame = (gameName:String) -> {
                final testState = new GameStateFactory().createGameState(gameName, plugin);
                testState.setFloat(StateKey.SECONDS_BETWEEN_TICKS, 5);
                testState.setFloat(StateKey.SECONDS_REMAINING, 100);
                testState.setString(StateKey.STAGE, "Test stage");

                gameLoader.initializeGame(testState, plugin);
            };
            generateGame("Test game 1");
            generateGame("Test game 2");
        }
    }

	public function disable(plugin:Plugin) {
    }
}