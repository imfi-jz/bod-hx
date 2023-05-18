package nl.imfi_jz.battlesofdestinyre.state;

abstract StateKey(Void) {
    public static inline final STAGE:String = "Stage";
    public static inline final SECONDS_REMAINING:String = "Seconds remaining";
    public static inline final PAUSED:String = "Paused";
    public static inline final SECONDS_BETWEEN_TICKS:String = "Seconds between ticks";
}