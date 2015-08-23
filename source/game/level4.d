module game.level4;

import d2d;
import game.collectable;
import game.commonlevel;
import game.groupmember;
import game.npc;
import game.deposit;
import game.fruits;
import game.condition;
import game.scene;
import game.endscreen;

class Level4 : CommonLevel
{
	Condition[] conditions;

	override void load()
	{
		levelTex = new Texture("res/levels/level4.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);

		super.load();

		player.minX = 121 * 4;
		player.minY = 172 * 4;

		collectables ~= new Collectable(items, 0.4f, vec2(218, 200) * 4, vec4(0.25f, 0.25f, 0.375f, 0.375f), CollectableItems.Bottle);
		collectables ~= new Collectable(items, 1.1f, vec2(201, 187) * 4, vec4(0, 0.125f, 0.125f, 0.25f), CollectableItems.Sandwich);
		collectables ~= new Collectable(items, 0.2f, vec2(128, 307) * 4, vec4(0.375f, 0.125f, 0.5f, 0.25f), CollectableItems.Salt);
		collectables ~= new Collectable(items, 0.79f, vec2(300, 340) * 4, vec4(0.375f, 0.25f, 0.5f, 0.375f), CollectableItems.Cat);

		interactables ~= new Deposit(this, RectangleShape.create(items, vec2(121, 264) * 4, vec2(64, 128), vec4(0.25f, 0.5f, 0.375f, 0.75f)));

		conditions ~= new Condition(this, items, vec2(150, 225) * 4, vec4(0.25f, 0.25f, 0.375f, 0.375f), CollectableItems.Bottle);
		conditions ~= new Condition(this, items, vec2(150, 245) * 4, vec4(0, 0.125f, 0.125f, 0.25f), CollectableItems.Sandwich);
		conditions ~= new Condition(this, items, vec2(150, 265) * 4, vec4(0.375f, 0.125f, 0.5f, 0.25f), CollectableItems.Salt);

		foreach (c; conditions)
			interactables ~= c;

		npcs ~= new NPC([vec2(135, 245) * 4, vec2(135 * 4 - 1, 245 * 4)], 1000000000);

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

		return met;
	}

	override Scene prepareNext()
	{
		dispose();
		return new EndScreen();
	}

	override bool isRelevant(int id)
	{
		if (id == CollectableItems.Bottle)
			return true;
		if (id == CollectableItems.Sandwich)
			return true;
		if (id == CollectableItems.Salt)
			return true;
		return false;
	}
}
