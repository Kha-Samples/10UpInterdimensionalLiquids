package;

import TenUp3.Mode;
import kha2d.Scene;

interface DialogueItem {
	public function execute() : Void;
	public var finished(default, null) : Bool;
}

@:access(TenUp3.mode)
class Dialogue {
	private static var items: Array<DialogueItem>;
	private static var index: Int = -1;
	public static var isActionActive(default,null): Bool = false;
	
	public static function set(items: Array<DialogueItem>): Void {
		if (items == null || items.length <= 0) {
			return;
		}
		if (Player.current() != null) {
			Player.current().left = false;
			Player.current().up = false;
			Player.current().right = false;
		}
		Dialogue.items = items;
		index = -1;
		TenUp3.getInstance().mode = Mode.BlaBlaBla;
		//kha.Sys.mouse.hide();
		next();
	}
	
	public static function insert(items: Array<DialogueItem>, argl = false) {
		if (Dialogue.items == null) {
			set(items);
		} else if (index < 0) {
			for (item in Dialogue.items) {
				items.push(item);
			}
			Dialogue.items = items;
		} else {
			var newItems = new Array<DialogueItem>();
			if (!argl) {
				newItems.push(Dialogue.items[index]);
			}
			for (item in items) {
				newItems.push(item);
			}
			if (!argl) {
				++index;
			}
			while (index < Dialogue.items.length) {
				newItems.push(Dialogue.items[index]);
				++index;
			}
			index = 0;
			Dialogue.items = newItems;
		}
	}
	
	public static function update() : Void {
		if (index >= 0 && !items[index].finished) {
			items[index].execute();
		}
	}
	
	@:access(TenUp3.subgame)
	public static function next(): Void {
		if (items == null) return;
		
		if (index >= 0 && !items[index].finished) {
			items[index].execute();
			return;
		}
		
		++index;
		BlaBox.pointAt(null);
		BlaBox.setText(null);
		
		if (index >= items.length) {
			TenUp3.getInstance().mode = Mode.Game;
			if (TenUp3.instance.subgame == TenUp3.SubGame.TEN_UP_3) {
				//kha.Sys.mouse.show();
			}
			items = null;
			index = -1;
			return;
		}
		
		items[index].execute();
	}
}
