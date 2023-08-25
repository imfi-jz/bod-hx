package nl.imfi_jz.battlesofdestinyre.game.event;

import nl.imfi_jz.minecraft_api.Gate.SharedPluginMemory;

@:deprecated
class CommonGameEventData {
    public final sharedMemory:SharedPluginMemory;
    public final game:InitializedGame;

    public inline function new(game, sharedMemory) {
        this.sharedMemory = sharedMemory;
        this.game = game;
    }
}