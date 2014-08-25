package;

import dialogue.EndGame;
import kha.Animation;
import kha.Color;
import kha.graphics2.Graphics;
import kha.Loader;
import kha.math.Vector2;
import kha.Rectangle;
import kha.Scene;
import kha.Scheduler;
import kha.Sprite;

class ZeroEightFifteenMan extends Player {
	private static var me: ZeroEightFifteenMan;
	
	public static function the(): ZeroEightFifteenMan {
		return me;
	}
	
	public function new(x: Float, y: Float) {
		super(x, y - 8, "professor", Std.int(410 / 10 * 2), Std.int(455 / 7 * 2));
		me = this;
		Player.setPlayer(1, this);
				
		collider = new Rectangle(10 * 2, 15 * 2, (41 - 20) * 2, ((65 - 1) - 15) * 2);
		walkLeft = Animation.createRange(11, 18, 4);
		walkRight = Animation.createRange(1, 8, 4);
		standLeft = Animation.create(10);
		standRight = Animation.create(0);
		jumpLeft = Animation.create(16);
		jumpRight = Animation.create(6);
	}
	
	override public function update():Void {
		if (health <= 0) return;
		super.update();
		
		if (x > Cfg.mannPositions[0].x + 300) {
			doEnde = true;
		} else if (x < Cfg.mannPositions[0].x + 75 && doEnde) {
			doEnde = false;
			Dialogues.setMannEndeDlg();
		}
	}
	
	var doEnde = false;
	var doCent = true;
	var doTheke = true;
	override public function hit(sprite:Sprite):Void 
	{
		super.hit(sprite);
		if (doCent) {
			if (sprite == Cfg.cent) {
				doCent = false;
				Dialogues.setGeldGefundenMannDlg();
			}
		}
		if (doTheke) {
			if (sprite == Cfg.theke) {
				doTheke = false;
				Dialogues.setVerkaufMannDlg();
			}
		}
		
		if (Std.is(sprite, Bratpfanne) || Std.is(sprite, Shot)) {
			die();
			if (Std.is(sprite, Bratpfanne)) {
				sprite.speedx = 0;
			}
		}
	}
	
	private function die(): Void {
		if (health > 0) {
			health = 0;
			if (lookRight) setAnimation(Animation.create(22));
			else setAnimation(Animation.create(23));
			speedx = 0;
			Scheduler.addTimeTask(Dialogues.setGameEnd, 1);
		}
	}
}
