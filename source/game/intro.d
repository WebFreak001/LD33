module game.intro;

import d2d;
import std.file;
import game.scene;
import game.level1;

class Intro : Scene
{
	TTFFont font;
	TTFText header, content, tip;
	string[] data;
	int index = -1;

	override void load()
	{
		font = new TTFFont();
		font.load("res/font/RobotoMono.ttf", 40);

		header = cast(TTFText) font.render("HEADER", 1.0f);
		content = cast(TTFText) font.renderMultiline("CONTENT", 0.6f);
		tip = cast(TTFText) font.render("PRESS ANY KEY TO CONTINUE", 0.6f);

		header.position = vec2(125, 100);
		content.position = vec2(125 * 1.6666f, 250);
		tip.position = vec2(315 * 1.6666f, 500);

		data = readText("res/text/story.txt").split("\n\n");
		advance();
	}

	override void dispose()
	{
		header.dispose();
		content.dispose();
		tip.dispose();
		font.dispose();
		data.length = 0;
	}

	void advance()
	{
		index++;
		if (index == data.length)
		{
			dispose();
			next(new Level1());
			return;
		}
		int firstBR = data[index].indexOf('\n');
		header.text = data[index][0 .. firstBR].strip();
		content.text = data[index][firstBR + 1 .. $].strip();
	}

	override void onEvent(Event event)
	{
		if (event.type == Event.Type.KeyReleased)
			advance();
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
