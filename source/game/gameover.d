module game.gameover;

import d2d;
import game.scene;
import game.level1;
import ld33;

class GameOver : Scene
{
	TTFFont font;
	TTFText header, content, tip;
	bool ripAttention;

	this(bool attention)
	{
		ripAttention = attention;
	}

	override void load()
	{
		font = new TTFFont();
		font.load("res/font/RobotoMono.ttf", 40);

		header = cast(TTFText) font.render("GAME OVER", 1.0f);
		content = cast(TTFText) font.renderMultiline(ripAttention ? "YOU DID  TOO MANY BAD THINGS  IN FRONT\nOF PEOPLE  AND THEY KICKED  YOU OUT OF\nTHE TOWN!" : "YOU  WANTED TO  DO BAD THINGS  SO HARD,\nTHAT YOU HAVE STARTED KILLING EVERYONE!", 0.6f);
		tip = cast(TTFText) font.render("PRESS ENTER TO CONTINUE", 0.6f);

		header.position = vec2(125, 100);
		content.position = vec2(125 * 1.6666f, 250);
		tip.position = vec2(315 * 1.6666f, 500);

		Score.collected.length = 0;
		Score.score = 0;
		Score.penalties = 0;
	}

	override void dispose()
	{
		header.dispose();
		content.dispose();
		tip.dispose();
		font.dispose();
	}

	override void onEvent(Event event)
	{
		if (event.type == Event.Type.KeyReleased && event.key == SDLK_RETURN)
		{
			dispose();
			next(new Level1());
			return;
		}
	}

	override void update(float delta)
	{
	}

	override void draw(IRenderTarget target)
	{
		target.draw(header);
		target.draw(content);
		target.draw(tip);
	}
}
