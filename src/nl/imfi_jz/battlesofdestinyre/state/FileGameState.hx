package nl.imfi_jz.battlesofdestinyre.state;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.KeyValueFile.NestableKeyValueFile;

class FileGameState implements GameState {
    private final file:NestableKeyValueFile<Any>;

    public function new(file) {
        this.file = file;
    }

	public function getName():String {
		final fileName = file.getName();
		Debugger.log('Actual file name: $fileName');
		return fileName.substring(0, fileName.lastIndexOf('.'));
	}

	public function getString(key:Array<String>):String {
		return file.getValueByNestedKey(key);
	}

	public function setString(key:Array<String>, value:String) {
		file.setValueByNestedKey(key, value);
	}

	public function getFloat(key:Array<String>):Float {
		return Std.parseFloat(file.getValueByNestedKey(key));
	}

	public function setFloat(key:Array<String>, value:Float) {
		if(value == cast(value, Int)){
			file.setValueByNestedKey(key, Std.int(value));
		}
		else {
			file.setValueByNestedKey(key, value);
		}
	}

	public function getBool(key:Array<String>):Bool {
		return file.getValueByNestedKey(key);
	}

	public function setBool(key:Array<String>, value:Bool) {
		file.setValueByNestedKey(key, value);
	}

	public function getStringArray(key:Array<String>):Array<String> {
		return file.getValueByNestedKey(key);
	}

	public function setStringArray(key:Array<String>, value:Array<String>) {
		file.setValueByNestedKey(key, value);
	}
}