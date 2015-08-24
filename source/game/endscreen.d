module game.endscreen;

import d2d;
import game.scene;
import std.file;
import std.format;
import ld33;

class EndScreen : Scene
{
	TTFFont font;
	TTFText header, content;
	Sound end;

	override void load()
	{
		font = new TTFFont();
		font.load("res/font/RobotoMono.ttf", 24);

		end = new Sound("res/sfx/end.wav");
		end.play();

		header = cast(TTFText) font.render("THE END", 1.0f);
		int score = cast(int) (Score.score * 100);
		int penalties = cast(int) (Score.penalties * 100);
		int bonus = cast(int) (Score.collected.length * 250);
		content = cast(TTFText) font.renderMultiline(format("Score: %s - %s + %s = %s\nItems Disposed: %s (+%s)\n\n", score, penalties, bonus, score - penalties + bonus, Score.collected.length, bonus) ~readText("res/text/end.txt"), 0.6f);

		header.position = vec2(50, 75);
		content.position = vec2(50 * 1.6666f, 120 * 1.6666f);
	}

	override void dispose()
	{
		header.dispose();
		content.dispose();
		font.dispose();
	}

	override void onEvent(Event event)
	{
		if (event.type == Event.Type.KeyReleased && event.key == SDLK_RETURN)
		{
			core.stdc.stdlib.exit(0);
		}
	}

	override void update(float delta)
	{
	}

	override void draw(IRenderTarget target)
	{
		target.draw(header);
		target.draw(content);
	}
}
