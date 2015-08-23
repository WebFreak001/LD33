module game.level1;

import d2d;
import game.collectable;
import game.commonlevel;
import game.groupmember;
import game.npc;
import game.deposit;
import game.fruits;
import game.condition;
import game.scene;
import game.level2;

class Level1 : CommonLevel
{
	Condition[] conditions;

	override void load()
	{
		levelTex = new Texture("res/levels/level1.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);

		super.load();

		collectables ~= new Collectable(items, 0.36f, vec2(50, 310) * 4, vec4(0, 0.125f, 0.125f, 0.25f), CollectableItems.Sandwich);
		collectables ~= new Collectable(items, 0.22f, vec2(40, 130) * 4, vec4(0.125f, 0, 0.25f, 0.125f), CollectableItems.Plank);
		collectables ~= new Collectable(items, 0.11f, vec2(270, 180) * 4, vec4(0.125f, 0.125f, 0.25f, 0.25f), CollectableItems.Nail);
		collectables ~= new Collectable(items, 0.11f, vec2(300, 190) * 4, vec4(0.125f, 0.125f, 0.25f, 0.25f), CollectableItems.Nail);
		collectables ~= new Collectable(items, 0.79f, vec2(100, 340) * 4, vec4(0.375f, 0.25f, 0.5f, 0.375f), CollectableItems.Cat);
		collectables ~= new Collectable(items, 0.14f, vec2(44, 336) * 4, vec4(0.125f, 0.25f, 0.25f, 0.375f), CollectableItems.String);

		interactables ~= new Deposit(this, RectangleShape.create(items, vec2(300, 500), vec2(64, 128), vec4(0.25f, 0.5f, 0.375f, 0.75f)));
		interactables ~= new Fruits(this, items, vec2(224, 60) * 4, vec4(0.125f, 0.5f, 0.25f, 0.625f), vec4(0, 0.75f, 0.125f, 0.875f));
		interactables ~= new Fruits(this, items, vec2(239, 60) * 4, vec4(0.125f, 0.5f, 0.25f, 0.625f), vec4(0, 0.75f, 0.125f, 0.875f));
		interactables ~= new Fruits(this, items, vec2(239, 87) * 4, vec4(0, 0.5f, 0.125f, 0.625f), vec4(0, 0.75f, 0.125f, 0.875f));

		conditions ~= new Condition(this, items, vec2(140, 1) * 4, vec4(0, 0.125f, 0.125f, 0.25f), CollectableItems.Sandwich);
		conditions ~= new Condition(this, items, vec2(180, 1) * 4, vec4(0.125f, 0, 0.25f, 0.125f), CollectableItems.Plank);
		conditions ~= new Condition(this, items, vec2(140, 17) * 4, vec4(0.125f, 0.125f, 0.25f, 0.25f), CollectableItems.Nail);
		conditions ~= new Condition(this, items, vec2(180, 17) * 4, vec4(0.125f, 0.25f, 0.25f, 0.375f), CollectableItems.String);

		foreach (c; conditions)
			interactables ~= c;

		npcs ~= new NPC([vec2(220, 80) * 4, vec2(260, 80) * 4], 3);

		npcs ~= new GroupMember(player);
		npcs ~= new GroupMember(player);
		npcs ~= new GroupMember(player);
	}

	override Scene prepareNext()
	{
		dispose();
		return new Level2();
	}

	override bool conditionsMet()
	{
		bool met = true;

		foreach (condition; conditions)
			if (!condition.solved)
				met = false;

		return player.y < 32 && met;
	}

	override bool isRelevant(int id)
	{
		if (id == CollectableItems.Sandwich)
			return true;
		if (id == CollectableItems.Plank)
			return true;
		if (id == CollectableItems.Nail)
			return true;
		if (id == CollectableItems.String)
			return true;
		return false;
	}
}
