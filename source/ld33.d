module ld33;

import d2d;

import game.scene;
import game.intro;
import game.level1;
import game.level2;
import game.level3;
import game.level4;
import game.endscreen;
import game.collectable;

class Score
{
	static Collectable[] collected;
	static float score = 0;
	static float penalties = 0;
}

class LD33 : Game
{
	Scene scene;

	this()
	{
	}

	void dispose()
	{
		scene.dispose();
	}

	void next(Scene scene)
	{
		scene.next = &next;
		scene.load();
		this.scene = scene;
	}

	override void onEvent(Event event)
	{
		scene.onEvent(event);
	}

	override void start()
	{
		maxFPS = 60;
		windowTitle = "Game with an epic plot";
	}

	override void load()
	{
		next(new Intro());
	}

	override void update(float delta)
	{
		scene.update(delta);
	}

	override void draw()
	{
		window.clear(0.01f, 0.01f, 0.01f);

		scene.draw(window);
	}
}

void main()
{
	auto game = new LD33();
	scope (exit) core.stdc.stdlib.exit(0);
	game.run();
}
