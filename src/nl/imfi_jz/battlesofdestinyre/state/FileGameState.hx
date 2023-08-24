package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.KeyValueFile.NestableKeyValueFile;

class FileGameState implements GameState {
    private final file:NestableKeyValueFile<Any>;

    public function new(file) {
        this.file = file;
    }

	public function getName():String {
		return file.getName();
	}

	public function getString(key:StateKey):String {
		return file.getValueByNestedKey(key);
	}

	public function setString(key:StateKey, value:String) {
		file.setValueByNestedKey(key, value);
	}

	public function getFloat(key:StateKey):Null<Float> {
		final value = file.getValueByNestedKey(key);
		if(value == null){
			return null;
		}
		else return Std.parseFloat(value);
	}

	public function setFloat(key:StateKey, value:Null<Float>) {
		if(value == null){
			file.setValueByNestedKey(key, null);
		}
		else if(value == cast(value, Int)){
			Debugger.log('Saving float as int: $value');
			file.setValueByNestedKey(key, Std.int(value));
		}
		else {
			file.setValueByNestedKey(key, value);
		}
	}

	public function getBool(key:StateKey):Null<Bool> {
		return file.getValueByNestedKey(key);
	}

	public function setBool(key:StateKey, value:Null<Bool>) {
		file.setValueByNestedKey(key, value);
	}

	public function getStringArray(key:StateKey):Array<String> {
		return file.getValueByNestedKey(key);
	}

	public function setStringArray(key:StateKey, value:Array<String>) {
		file.setValueByNestedKey(key, value);
	}

	public function getAllBoolStateKeysPresent():Array<Array<String>> {
		return file.getNestedKeys().filter((key) -> file.getValueByNestedKey(key) is Bool);
	}

	public function getAllFloatStateKeysPresent():Array<Array<String>> {
		return file.getNestedKeys().filter((key) -> !Math.isNaN(Std.parseFloat(file.getValueByNestedKey(key))));
	}

	public function getAllStringStateKeysPresent():Array<Array<String>> {
		return file.getNestedKeys().filter((key) -> file.getValueByNestedKey(key) is String);
	}

	public function getAllStringArrayStateKeysPresent():Array<Array<String>> {
		return file.getNestedKeys().filter((key) -> file.getValueByNestedKey(key) is Array);
	}
}