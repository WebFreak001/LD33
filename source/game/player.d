module game.player;

import d2d;

class Player : IDrawable
{
	float x, y;
	float xa, ya;
	Texture tex;
	RectangleShape rect;
	float rotation;
	int minY = 0;
	int minX = 0;

	this()
	{
		xa = ya = 0;
		x = 384 * 2 - 32;
		y = 384 * 4 - 100;
		tex = new Texture("res/tex/player.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);
		rect = RectangleShape.create(tex, vec2(0, 0), vec2(64, 64));
		rect.origin = vec2(32, 32);
		rotation = 0;
	}

	void move(float x, float y)
	{
		xa += x;
		ya += y;
	}

	void update()
	{
		import gl3n.math : abs;

		x += xa;
		y += ya;

		xa *= 0.8f;
		ya *= 0.8f;

		if (x < minX)
			x = minX;
		if (y < minY)
			y = minY;
		if (x > 384 * 4)
			x = 384 * 4;
		if (y > 384 * 4)
			y = 384 * 4;

		if (abs(xa) > 0.01f || abs(ya) > 0.01f)
			rotation = atan2(-xa, ya);
	}

	bool intersects(RectangleShape shape)
	{
		return (vec2(x - 32, y - 32) - (shape.position - shape.origin)).length_squared < 64 * 64;
	}

	override void draw(IRenderTarget target, ShaderProgram shader = null)
	{
		rect.position = vec2(x, y);
		rect.rotation = rotation + 3.14159265f;
		rect.draw(target, shader);
	}
}
