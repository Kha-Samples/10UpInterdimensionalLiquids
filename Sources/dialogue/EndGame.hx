package dialogue;

import kha2d.Scene;

class EndGame implements Dialogue.DialogueItem
{
	public function new() {}
	
	public var finished(default, null) : Bool = true;
	
	public function execute(): Void {
		Dialogues.setGameEnd();
		Dialogue.next();
	}
}