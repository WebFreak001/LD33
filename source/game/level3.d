module game.level3;

import d2d;
import game.collectable;
import game.commonlevel;
import game.groupmember;
import game.npc;
import game.deposit;
import game.fruits;
import game.condition;
import game.scene;
import game.level4;

class Level3 : CommonLevel
{
	Condition[] conditions;

	override void load()
	{
		levelTex = new Texture("res/levels/level3.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);

		super.load();

		player.minY = 172 * 4;

		collectables ~= new Collectable(items, 0.67f, vec2(185, 243) * 4, vec4(0.25f, 0.25f, 0.375f, 0.375f), CollectableItems.Bottle);
		collectables ~= new Collectable(items, 1.1f, vec2(10, 220) * 4, vec4(0, 0.125f, 0.125f, 0.25f), CollectableItems.Sandwich);
		collectables ~= new Collectable(items, 0.2f, vec2(100, 340) * 4, vec4(0.375f, 0, 0.5f, 0.125f), CollectableItems.Glove);
		collectables ~= new Collectable(items, 0.79f, vec2(100, 240) * 4, vec4(0.375f, 0.25f, 0.5f, 0.375f), CollectableItems.Cat);

		interactables ~= new Deposit(this, RectangleShape.create(items, vec2(107, 264) * 4, vec2(64, 128), vec4(0.25f, 0.5f, 0.375f, 0.75f)));

		conditions ~= new Condition(this, items, vec2(20, 270) * 4, vec4(0.25f, 0.25f, 0.375f, 0.375f), CollectableItems.Bottle);
		conditions ~= new Condition(this, items, vec2(20, 290) * 4, vec4(0, 0.125f, 0.125f, 0.25f), CollectableItems.Sandwich);
		conditions ~= new Condition(this, items, vec2(20, 310) * 4, vec4(0.375f, 0, 0.5f, 0.125f), CollectableItems.Glove);

		foreach (c; conditions)
			interactables ~= c;

		npcs ~= new NPC([vec2(10, 200) * 4, vec2(10, 260) * 4], 3);

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

		return player.x < 32 && met;
	}

	override Scene prepareNext()
	{
		dispose();
		return new Level4();
	}

	override bool isRelevant(int id)
	{
		if (id == CollectableItems.Bottle)
			return true;
		if (id == CollectableItems.Sandwich)
			return true;
		if (id == CollectableItems.Glove)
			return true;
		return false;
	}
}
