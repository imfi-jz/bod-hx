package nl.imfi_jz.battlesofdestinyre.state.player;

import java.io.ByteArrayInputStream;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import java.util.Base64;
import java.io.ByteArrayOutputStream;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.minecraft_api.KeyValueFile.NestableKeyValueFile;

class PlayerStateStorage {
    private static inline final INVENTORY_KEY = "inventory";

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

    public function storePlayerState(player:Player) {
        storeInventory(player);
    }

    private function storeInventory(player:Player) {
        try {
            final outputStream = new ByteArrayOutputStream();
            trace('outputStream: $outputStream');
            final dataOutput:Dynamic = untyped __java__("new org.bukkit.util.io.BukkitObjectOutputStream({0})", outputStream);
            trace('dataOutput: $dataOutput');
            final bukkitInventory:Dynamic = playerToBukkitInventory(player);
            trace('bukkitInventory: $bukkitInventory');

            for(i in 0...bukkitInventory.getSize()){
                final itemStack = bukkitInventory.getItem(i);
                trace('itemStack: $itemStack');
                dataOutput.writeObject(itemStack);
            }

            trace('Closing dataOutput');
            dataOutput.close();
            trace('Encoding output stream');
            final inventoryBase64 = Base64.getEncoder().encodeToString(outputStream.toByteArray());

            trace('Storing player inventory');
            file.setValueByNestedKey([player.getUniqueIdentifier(), INVENTORY_KEY], inventoryBase64);

            trace('Clearing player inventory');
            bukkitInventory.clear();
        }
        catch(ex) {
            Debugger.warn('Failed to store player state for player ' + player.getName());
            throw ex;
        }
    }

    private function restoreInventory(destinationPlayer:Player) {
        final uid = destinationPlayer.getUniqueIdentifier();
        final inventoryBase64:String = file.getValueByNestedKey([uid, INVENTORY_KEY]);
        try {
            final inputStream = new ByteArrayInputStream(Base64.getDecoder().decode(inventoryBase64));
            trace('inputStream: $inputStream');
            final dataInput:Dynamic = untyped __java__("new org.bukkit.util.io.BukkitObjectInputStream({0})", inputStream);
            trace('dataInput: $dataInput');
            final bukkitInventory:Dynamic = playerToBukkitInventory(destinationPlayer);
            trace('bukkitInventory: $bukkitInventory');

            trace('Clearing bukkit inventory');
            bukkitInventory.clear();

            for (i in 0...bukkitInventory.getSize()){
                final itemStack:Dynamic = untyped __java__("(org.bukkit.inventory.ItemStack) {0}.readObject()", dataInput);
                trace('itemStack: $itemStack');
                bukkitInventory.setItem(i, itemStack);
            }
            trace('Closing dataInput');
            dataInput.close();

            trace('Removing player inventory from storage');
            file.setValueByNestedKey([uid, INVENTORY_KEY], null);
        }
        catch (ex) {
            Debugger.warn('Failed to restore player state for player ' + destinationPlayer.getName());
            throw ex;
        }
    }

    public function containsPlayerState(player:Player):Bool {
        return file.getKeys().contains(player.getUniqueIdentifier());
    }
}