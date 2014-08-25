package;

import kha.Animation;
import kha.Direction;
import kha.Loader;
import kha.math.Random;
import kha.Scene;
import kha.Sprite;

class Portal extends Sprite {
	private var count: Int = 0;
	private var water: Water;
	private var lava: Lava;
	public var canIndex: Int;
	
	public function new(x: Float, y: Float, speedx: Float, speedy: Float, canIndex: Int) {
		super(Loader.the.getImage('portal'), 32, 32);
		this.x = x;
		this.y = y;
		this.speedx = speedx;
		this.speedy = speedy;
		accy = 0;
		this.canIndex = canIndex;
	}
	
	public function remove(): Void {
		if (water != null) {
			Scene.the.removeOther(water);
		}
		if (lava != null) {
			Scene.the.removeOther(lava);
		}
	}
	
	override public function hitFrom(dir: Direction): Void {
		super.hitFrom(dir);
		speedx = 0;
		speedy = 0;
		switch (canIndex) {
			case 0:
				switch (dir) {
					case UP:
						setAnimation(Animation.create(2));
						Scene.the.addOther(water = new Water(x, y, 12, -0));
					case LEFT:
						setAnimation(Animation.create(1));
						Scene.the.addOther(water = new Water(x, y, -12, 0));
					case RIGHT:
						setAnimation(Animation.create(4));
						Scene.the.addOther(water = new Water(x, y, 12, 0));
					case DOWN:
						setAnimation(Animation.create(3));
						Scene.the.addOther(water = new Water(x, y, -12, 0));
				}
			case 1:
				switch (dir) {
				case UP:
					setAnimation(Animation.create(2));
					Scene.the.addOther(lava = new Lava(x, y, 12, -0));
				case LEFT:
					setAnimation(Animation.create(1));
					Scene.the.addOther(lava = new Lava(x, y, -12, 0));
				case RIGHT:
					setAnimation(Animation.create(4));
					Scene.the.addOther(lava = new Lava(x, y, 12, 0));
				case DOWN:
					setAnimation(Animation.create(3));
					Scene.the.addOther(lava = new Lava(x, y, -12, 0));
				}
			default:
				switch (dir) {
					case UP:
						setAnimation(Animation.create(2));
					case LEFT:
						setAnimation(Animation.create(1));
					case RIGHT:
						setAnimation(Animation.create(4));
					case DOWN:
						setAnimation(Animation.create(3));
				}
		}
	}
	
	override public function update(): Void {
		super.update();
		if (speedx == 0 && speedy == 0) {
			++count;
			if (count % 5 == 0) {
				var x = this.x;
				var y = this.y;
				switch (animation.get()) {
					case 1:
						x += 0;
						y += height / 2;
					case 2:
						x += 0;
						y -= 16;
					case 3:
						x += width / 2;
						y += 0;
					case 4:
						x += 0;
						y += 8;
				}
				switch (canIndex) {
					case 0:
						Scene.the.addProjectile(new WaterSplash(x, y, (Random.getIn(0, 2000) - 1000) / 250, -4));
					case 1:
						Scene.the.addProjectile(new LavaSplash(x, y, (Random.getIn(0, 2000) - 1000) / 250, -4));
					case 2:
						if (count % 50 == 0) Scene.the.addOther(new Gas(x + (Random.getIn(0, 2000) - 1000) / 100, y));
				}
			}
		}
	}
}
