package;

import kha.Animation;
import kha.Direction;
import kha.Loader;
import kha.math.Vector2i;
import kha.Sprite;

class Water extends Sprite {
	private var lastTile: Vector2i;
	private var floored: Bool = false;
	private var right: Animation;
	private var left: Animation;
	
	public function new(x: Float, y: Float, speedx: Float, speedy: Float) {
		super(Loader.the.getImage("water"), 32, 32);
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		this.speedy = speedy;
		left = Animation.create(0);
		right = Animation.create(1);
		if (speedx > 0) setAnimation(right);
		else setAnimation(left);
	}
	
	override public function update(): Void {
		super.update();
		splash();
	}
	
	private function splash(): Void {
		var tile = Level.liquids.index(x, y + height - 1);
		var value = Level.liquids.get(tile.x, tile.y);
		if (lastTile == null || tile.x != lastTile.x || tile.y != lastTile.y) {
			lastTile = tile;
			if (floored) {
				if (value > 0 && value < 17) Level.liquids.set(tile.x, tile.y, value + 1);
			}
		}
		floored = false;
	}
	
	override public function hitFrom(dir: Direction): Void {
		super.hitFrom(dir);
		if (dir == Direction.UP) floored = true;
		if (dir == Direction.LEFT || dir == Direction.RIGHT) {
			speedx = -speedx;
			
			if (speedx < 0) setAnimation(left);
			else setAnimation(right);
			
			lastTile = null;
		}
	}
}
