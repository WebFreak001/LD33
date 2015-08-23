module game.fruits;

import d2d;

import ld33;
import game.interactable;
import game.commonlevel;

class Fruits : Interactable
{
	CommonLevel level;
	vec4 destroyed;
	bool alive = true;

	this(CommonLevel level, Texture tex, vec2 position, vec4 orig, vec4 destroyed)
	{
		super(RectangleShape.create(tex, position, vec2(64, 64), orig));
		this.level = level;
		this.destroyed = destroyed;
	}

	override bool interact()
	{
		if (alive)
		{
			alive = false;
			rect.texCoords = destroyed;
			rect.create();
			level.checkSuspect(rect.position + vec2(32, 32), 0.54f);
			return true;
		}
		return false;
	}
}
