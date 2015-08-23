module game.commonlevel;

import d2d;
import game.scene;
import fx.bar;
import std.file;
import std.random;
import game.player;
import game.npc;
import game.collectable;
import game.interactable;
import game.gameover;
import ld33;

alias Keyboard = bool[dchar];

class CommonLevel : Scene
{
	Texture levelTex, items, barTex;
	BarShader barShader;
	Sound pickup, seen, gameover;
	RectangleShape bar1, bar2;
	RectangleShape level;
	Collectable[] collectables;
	Interactable[] interactables;
	Collectable[3] inventory;
	Keyboard keys;
	Player player;
	float attention = 0, need = 0;
	TTFFont font;
	IText[] seenText;
	NPC[] npcs;

	override void load()
	{
		items = new Texture("res/tex/items.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);
		barTex = new Texture("res/tex/bar.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);

		pickup = new Sound("res/sfx/pickup.wav");
		seen = new Sound("res/sfx/seen.wav");
		gameover = new Sound("res/sfx/gameover.wav");

		font = new TTFFont();
		font.load("res/font/RobotoMono.ttf", 16);
		string[] texts = readText("res/text/seen.txt").split('\n');
		foreach (text; texts)
			if (text.length > 0)
				seenText ~= font.render(text, 1.0f);

		level = RectangleShape.create(levelTex, vec2(0, 0), vec2(384, 384) * 4);
		bar1 = RectangleShape.create(barTex, vec2(10, 442), vec2(32, 8) * 4);
		bar2 = RectangleShape.create(barTex, vec2(10, 402), vec2(32, 8) * 4);

		barShader = new BarShader();

		player = new Player();
	}

	override void dispose()
	{
		items.dispose();
		levelTex.dispose();
		barTex.dispose();
		font.dispose();
		bar1.dispose();
		bar2.dispose();
		level.dispose();

		foreach (text; seenText)
			text.dispose();

		foreach (interactable; interactables)
			interactable.rect.dispose();
		foreach (item; inventory)
			if (item !is null)
				item.rect.dispose();
	}

	override void onEvent(Event event)
	{
		switch (event.type)
		{
		case Event.Type.KeyPressed:
			keys[event.key] = true;
			break;
		case Event.Type.KeyReleased:
			keys[event.key] = false;

			if (event.key == SDLK_SPACE)
			{
				foreach (interactable; interactables)
					if (player.intersects(interactable.rect) || interactable.customIntersect(player))
					{
						if (interactable.interact())
							return;
					}
			}

			if (event.key == SDLK_e)
			{
				if (inventory[0] !is null && inventory[1] !is null && inventory[2] !is null)
					return;
				foreach_reverse (i, collectable; collectables)
				{
					if (player.intersects(collectable.rect))
					{
						auto lhs = collectables[0 .. i];
						auto rhs = collectables[i + 1 .. $];
						collectables = lhs ~ rhs;
						if (inventory[0] is null)
							inventory[0] = collectable;
						else if (inventory[1] is null)
							inventory[1] = collectable;
						else
							inventory[2] = collectable;
						checkSuspect(collectable.rect.position + vec2(32, 32), collectable.stealWorth);
					}
				}
			}
			break;
		default:
			break;
		}
	}

	abstract bool isRelevant(int id);

	abstract bool conditionsMet();

	abstract Scene prepareNext();

	void checkSuspect(vec2 pos, float penalty)
	{
		need -= penalty * 1.5f;
		Score.score += penalty * 1.5f;
		bool hasSeen = false;
		foreach (npc; npcs)
			if (npc.canSee(vec2(player.x, player.y)) || npc.canSee(pos))
			{
				attention += penalty;
				Score.penalties += penalty;
				npc.speak(cast(TTFText) seenText[uniform(0, seenText.length)], 2.0f);
				hasSeen = true;
			}
		if (hasSeen)
		{
			seen.play();
		}
		else
		{
			pickup.play();
		}
	}

	bool isKeyDown(dchar key)
	{
		return (key in keys) !is null && keys[key];
	}

	override void update(float delta)
	{
		attention -= delta * 0.03f;
		need += delta * 0.07f;
		if (attention < 0)
			attention = 0;
		if (need < 0)
			need = 0;
		if (attention >= 1 || need >= 1)
		{
			gameover.play();
			dispose();
			next(new GameOver(attention >= 1));
			return;
		}

		if (conditionsMet())
		{
			next(prepareNext());
			return;
		}

		foreach (npc; npcs)
			npc.update(delta);
		player.update();

		if (isKeyDown(SDLK_w))
			player.move(0, -1);
		if (isKeyDown(SDLK_a))
			player.move(-1, 0);
		if (isKeyDown(SDLK_s))
			player.move(0, 1);
		if (isKeyDown(SDLK_d))
			player.move(1, 0);
	}

	override void draw(IRenderTarget target)
	{
		matrixStack.push();
		float x = player.x - 400;
		float y = player.y - 240;
		if (x < 0)
			x = 0;
		if (y < 0)
			y = 0;
		if (x > 384 * 4 - 800)
			x = 384 * 4 - 800;
		if (y > 384 * 4 - 480)
			y = 384 * 4 - 480;
		matrixStack.top = matrixStack.top * mat4.identity.translate2d(-x, -y);
		target.draw(level);

		foreach (collectable; collectables)
			target.draw(collectable.rect);

		foreach (interactable; interactables)
			interactable.draw(target);

		foreach (npc; npcs)
			target.draw(npc);
		target.draw(player);
		matrixStack.pop();

		barShader.bind();
		barShader.set("progress", need);
		target.draw(bar1, barShader);

		barShader.set("progress", attention);
		target.draw(bar2, barShader);

		foreach (i, collectable; inventory)
		{
			if (collectable !is null)
			{
				collectable.rect.position = vec2(300 + i * 100, 400);
				target.draw(collectable.rect);
			}
		}
	}
}
