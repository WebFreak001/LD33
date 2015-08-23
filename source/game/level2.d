module game.level2;

import d2d;
import game.collectable;
import game.commonlevel;
import game.groupmember;
import game.npc;
import game.deposit;
import game.fruits;
import game.condition;
import game.scene;
import game.level3;

class Level2 : CommonLevel
{
	Condition[] conditions;

	override void load()
	{
		levelTex = new Texture("res/levels/level2.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);

		super.load();

		collectables ~= new Collectable(items, 0.67f, vec2(155, 243) * 4, vec4(0.25f, 0, 0.375f, 0.125f), CollectableItems.Axe);
		collectables ~= new Collectable(items, 0.17f, vec2(350, 350) * 4, vec4(0, 0, 0.125f, 0.125f), CollectableItems.SandwichBottom);
		collectables ~= new Collectable(items, 0.1f, vec2(80, 80) * 4, vec4(0, 0.25f, 0.125f, 0.375f), CollectableItems.SandwichBread);
		collectables ~= new Collectable(items, 0.2f, vec2(40, 230) * 4, vec4(0.25f, 0.125f, 0.375f, 0.25f), CollectableItems.Stick);
		collectables ~= new Collectable(items, 0.79f, vec2(100, 340) * 4, vec4(0.375f, 0.25f, 0.5f, 0.375f), CollectableItems.Cat);

		interactables ~= new Deposit(this, RectangleShape.create(items, vec2(107, 264) * 4, vec2(64, 128), vec4(0.25f, 0.5f, 0.375f, 0.75f)));

		conditions ~= new Condition(this, items, vec2(210, 250) * 4, vec4(0.25f, 0, 0.375f, 0.125f), CollectableItems.Axe);
		conditions ~= new Condition(this, items, vec2(250, 250) * 4, vec4(0, 0, 0.125f, 0.125f), CollectableItems.SandwichBottom);
		conditions ~= new Condition(this, items, vec2(210, 266) * 4, vec4(0, 0.25f, 0.125f, 0.375f), CollectableItems.SandwichBread);
		conditions ~= new Condition(this, items, vec2(250, 266) * 4, vec4(0.25f, 0.125f, 0.375f, 0.25f), CollectableItems.Stick);

		foreach (c; conditions)
			interactables ~= c;

		npcs ~= new NPC([vec2(247, 241) * 4, vec2(247 * 4 - 1, 241 * 4)], 10000000);

		npcs ~= new GroupMember(player);
		npcs ~= new GroupMember(player);
		npcs ~= new GroupMember(player);
	}

	override bool conditionsMet()
	{
		bool met = true;

		foreach (condition; conditions)
			if (!condition.solved)
				met = false;

		return player.y < 32 && met;
	}

	override Scene prepareNext()
	{
		dispose();
		return new Level3();
	}

	override bool isRelevant(int id)
	{
		if (id == CollectableItems.Axe)
			return true;
		if (id == CollectableItems.SandwichBottom)
			return true;
		if (id == CollectableItems.SandwichBread)
			return true;
		if (id == CollectableItems.Stick)
			return true;
		return false;
	}
}
