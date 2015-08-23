module game.deposit;

import d2d;

import ld33;
import game.interactable;
import game.commonlevel;

class Deposit : Interactable
{
	CommonLevel level;

	this(CommonLevel level, RectangleShape rect)
	{
		super(rect);
		this.level = level;
	}

	override bool interact()
	{
		bool found = false;
		for (int i = 0; i < 3; i++)
			if (level.inventory[i] !is null && !level.isRelevant(level.inventory[i].id))
			{
				level.checkSuspect(rect.position + vec2(32, 32), level.inventory[i].stealWorth);
				Score.collected ~= level.inventory[i];
				level.inventory[i] = null;
				found = true;
			}
		return found;
	}
}
