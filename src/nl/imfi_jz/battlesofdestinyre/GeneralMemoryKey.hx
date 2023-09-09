package nl.imfi_jz.battlesofdestinyre;

abstract GeneralMemoryKey(Array<String>) from Array<String> to Array<String> {
    public static final INITIALIZED_GAMES_MEMORY_KEY = ['games'];
    public static final LAST_GAME_ADDED_MEMORY_KEY = ['lastgameadded'];
    public static final TRACKED_KEYS_MEMORY_KEY = ['keys'];

    public static inline function getTrackedKeysMemoryKey(gameName:String):GeneralMemoryKey {
        return TRACKED_KEYS_MEMORY_KEY.concat([gameName]);
    }
}