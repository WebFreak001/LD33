module game.interactable;

import d2d;

import game.player;

class Interactable
{
	RectangleShape rect;

	this(RectangleShape rect)
	{
		this.rect = rect;
	}

	void draw(IRenderTarget target)
	{
		target.draw(rect);
	}

	bool customIntersect(Player player)
	{
		return false;
	}

	abstract bool interact();
}
