package nl.imfi_jz.battlesofdestinyre.state.player;

import nl.imfi_jz.functional.collection.Collection.Multitude;
import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.minecraft_api.implementation.unchanging.ThreeDimensional.UnchangingThreeDimensional;
import java.io.ByteArrayInputStream;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import java.util.Base64;
import java.io.ByteArrayOutputStream;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.minecraft_api.KeyValueFile.NestableKeyValueFile;

class PlayerStateStorage {
    private static inline final LOCATION_SECTION_KEY = 'location';
    private static inline final EXPERIENCE_SECTION_KEY = 'experience';

    private static final KEY = {
        INVENTORY: 'inventory',
        LOCATION_X: [LOCATION_SECTION_KEY, 'x'],
        LOCATION_Y: [LOCATION_SECTION_KEY, 'y'],
        LOCATION_Z: [LOCATION_SECTION_KEY, 'z'],
        LOCATION_WORLD: [LOCATION_SECTION_KEY, 'world'],
        HEALTH: 'health',
        EXPERIENCE_LEVEL: [EXPERIENCE_SECTION_KEY, 'level'],
        EXPERIENCE_POINTS: [EXPERIENCE_SECTION_KEY, 'points']
    };

    private final file:NestableKeyValueFile<Any>;

    public function new(file) {
        this.file = file;
    }

    private function playerToBukkitEntity(player:Player):Dynamic {
        return untyped __java__("((nl.imfi_jz.haxeminecraftapiconversion.adapter.gameObject.EntityGameObjectAdapter) {0}).getBukkitEntity()", player);
    }

    private function playerToBukkitInventory(player:Player):Dynamic {
        return playerToBukkitEntity(player).getInventory();
    }

    public function storePlayerState(player:Player, game:Game) {
        final uid = player.getUniqueIdentifier();
        storeInventory(uid, player);
        storeLocation(uid, player);
        storeHealth(uid, player);
        storeExperience(uid, player, game);
    }

    // TODO: Restore player state when a player joins the server and the game they're in is over
    public function restorePlayerState(player:Player, game:Game) {
        final uid = player.getUniqueIdentifier();
        restoreInventory(uid, player);
        restoreLocation(uid, player, game);
        restoreHealth(uid, player);
        restoreExperience(uid, player, game);
    }

    private function storeExperience(uid:String, player:Player, game:Game) {
        // Store experience
        file.setValueByNestedKey([uid].concat(KEY.EXPERIENCE_LEVEL), Math.floor(player.getExperienceLevel()));
        final experiencePoints = game.executeCommand('experience', ['query', player.getName(), 'points']);
        file.setValueByNestedKey([uid].concat(KEY.EXPERIENCE_POINTS), experiencePoints);

        // Reset experience
        // TODO: There is currently no API to set experience level
        game.executeCommand('experience', ['set', player.getName(), '0']);
    }

    private function restoreExperience(uid:String, player:Player, game:Game) {
        // Restore experience
        // TODO: There is currently no API to set experience level
        game.executeCommand('experience', ['set', player.getName(), file.getValueByNestedKey([uid].concat(KEY.EXPERIENCE_LEVEL)), 'levels']);
        game.executeCommand('experience', ['set', player.getName(), file.getValueByNestedKey([uid].concat(KEY.EXPERIENCE_POINTS)), 'points']);

        // Clear experience data
        file.setValueByNestedKey([uid].concat(KEY.EXPERIENCE_LEVEL), null);
        file.setValueByNestedKey([uid].concat(KEY.EXPERIENCE_POINTS), null);
    }

    private function storeHealth(uid:String, player:Player) {
        // Store health
        file.setValueByNestedKey([uid, KEY.HEALTH], player.getCondition().getCurrent());

        // Reset health
        player.heal(player.getCondition().getMax());
    }

    private function restoreHealth(uid:String, player:Player) {
        // Restore health
        final health:Float = file.getValueByNestedKey([uid, KEY.HEALTH]);
        player.damage(player.getCondition().getMax() - health);

        // Clear health data
        file.setValueByNestedKey([uid, KEY.HEALTH], null);
    }

    private function storeLocation(uid:String, player:Player) {
        // Store location
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_X), player.getCoordinates().getX());
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_Y), player.getCoordinates().getY());
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_Z), player.getCoordinates().getZ());
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_WORLD), player.getWorld().getName());

        // Location has no reset state
    }

    private function restoreLocation(uid:String, player:Player, game:Game) {
        // Restore location
        player.teleport(new UnchangingThreeDimensional(
            file.getValueByNestedKey([uid].concat(KEY.LOCATION_X)),
            file.getValueByNestedKey([uid].concat(KEY.LOCATION_Y)),
            file.getValueByNestedKey([uid].concat(KEY.LOCATION_Z))
        ), game.getWorlds().filter(world -> world.getName() == file.getValueByNestedKey([uid].concat(KEY.LOCATION_WORLD))).pop());

        // Clear location data
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_X), null);
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_Y), null);
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_Z), null);
        file.setValueByNestedKey([uid].concat(KEY.LOCATION_WORLD), null);
    }

    private function storeInventory(uid:String, player:Player) {
        final logs = [];
        try {
            final outputStream = new ByteArrayOutputStream();
            logs.push('outputStream: $outputStream');
            final dataOutput:Dynamic = untyped __java__("new org.bukkit.util.io.BukkitObjectOutputStream({0})", outputStream);
            logs.push('dataOutput: $dataOutput');
            final bukkitInventory:Dynamic = playerToBukkitInventory(player);
            logs.push('bukkitInventory: $bukkitInventory');

            for(i in 0...bukkitInventory.getSize()){
                final itemStack = bukkitInventory.getItem(i);
                logs.push('itemStack: $itemStack');
                dataOutput.writeObject(itemStack);
            }

            logs.push('Closing dataOutput');
            dataOutput.close();
            logs.push('Encoding output stream');
            final inventoryBase64 = Base64.getEncoder().encodeToString(outputStream.toByteArray());

            // Store inventory
            logs.push('Storing player inventory');
            file.setValueByNestedKey([uid, KEY.INVENTORY], inventoryBase64);

            // Reset inventory
            logs.push('Clearing player inventory');
            bukkitInventory.clear();
        }
        catch(ex) {
            Debugger.warn('Failed to store inventory for player ' + player.getName());
            final logsMult:Multitude<String> = logs;
            logsMult.each(log -> Debugger.warn(log));
            throw ex;
        }
    }

    private function restoreInventory(uid:String, player:Player) {
        final inventoryBase64:String = file.getValueByNestedKey([uid, KEY.INVENTORY]);
        final logs = [];
        try {
            final inputStream = new ByteArrayInputStream(Base64.getDecoder().decode(inventoryBase64));
            logs.push('inputStream: $inputStream');
            final dataInput:Dynamic = untyped __java__("new org.bukkit.util.io.BukkitObjectInputStream({0})", inputStream);
            logs.push('dataInput: $dataInput');
            final bukkitInventory:Dynamic = playerToBukkitInventory(player);
            logs.push('bukkitInventory: $bukkitInventory');

            // Restore inventory
            logs.push('Clearing bukkit inventory');
            bukkitInventory.clear();

            for (i in 0...bukkitInventory.getSize()){
                final itemStackObj:Dynamic = dataInput.readObject();
                final itemStack:Dynamic = untyped __java__("(org.bukkit.inventory.ItemStack) {0}", itemStackObj);
                logs.push('itemStack: $itemStack');
                bukkitInventory.setItem(i, itemStack);
            }
            logs.push('Closing dataInput');
            dataInput.close();

            // Clear inventory data
            logs.push('Removing player inventory from storage');
            file.setValueByNestedKey([uid, KEY.INVENTORY], null);
        }
        catch (ex) {
            Debugger.warn('Failed to restore inventory for player ' + player.getName());
            final logsMult:Multitude<String> = logs;
            logsMult.each(log -> Debugger.warn(log));
            throw ex;
        }
    }

    public function containsPlayerState(player:Player):Bool {
        return file.getKeys().contains(player.getUniqueIdentifier());
    }
}