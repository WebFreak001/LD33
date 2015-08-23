module game.condition;

import d2d;

import ld33;
import game.interactable;
import game.commonlevel;
import game.player;

class Condition : Interactable
{
	CommonLevel level;
	RectangleShape indicator;
	int id;
	vec2 position;
	bool solved = false;

	this(CommonLevel level, Texture tex, vec2 pos, vec4 uv, int id)
	{
		super(RectangleShape.create(tex, vec2(70, 0), vec2(64, 64), uv));
		indicator = RectangleShape.create(tex, vec2(0, 0), vec2(64, 64), vec4(0.625f, 0.5f, 0.75f, 0.625f));
		position = pos;
		this.id = id;
		this.level = level;
	}

	override void draw(IRenderTarget target)
	{
		matrixStack.push();
		matrixStack.top = matrixStack.top * mat4.identity.translate2d(position.x, position.y);
		target.draw(indicator);
		target.draw(rect);
		matrixStack.pop();
	}

	override bool customIntersect(Player player)
	{
		vec2 borderPos = position - vec2(32, 32);
		vec2 borderSize = vec2(32, 16) * 4 + vec2(64, 64);
		return player.x > borderPos.x && player.x < borderPos.x + borderSize.x &&
		       player.y > borderPos.y && player.y < borderPos.y + borderSize.y;
	}

	override bool interact()
	{
		for (int i = 0; i < 3; i++)
		{
			if (level.inventory[i] !is null && level.inventory[i].id == id)
			{
				level.inventory[i] = null;
				indicator.texCoords = vec4(0.75f, 0.5f, 0.875f, 0.625f);
				indicator.create();
				solved = true;
			}
		}
		return false; // It should activate all at once when standing in multiple
	}
}
