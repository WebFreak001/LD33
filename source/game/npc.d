module game.npc;

import d2d;

import fx.view;

class NPC : IDrawable
{
	vec2 pos;
	float rotation = 0.0f;
	Texture tex;
	RectangleShape rect;
	vec2[] path;
	int segment = 0;
	float segmentTime;
	float iSegmentTime;
	float time = 0;
	float speakTime = -1;
	TTFText spokenText;
	Mesh viewIndicator;
	ViewIndicatorShader viewIndicatorShader;

	this()
	{
		this.path = [];
		this.segmentTime = 0;
		iSegmentTime = 1;
		pos = vec2(0, 0);
		tex = new Texture("res/tex/npc.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);
		rect = RectangleShape.create(tex, vec2(0, 0), vec2(64, 64));
		rect.origin = vec2(32, 32);

		viewIndicator = new Mesh();
		viewIndicator.addVertices([vec3(0, 0, 0), vec3(-302.59f, 398.04f, 0), vec3(302.59f, 398.04f, 0)]);
		viewIndicator.addTexCoords([vec2(0, 0), vec2(1, 0), vec2(1, 1)]);
		viewIndicator.addIndices([0, 1, 2]);
		viewIndicator.create();

		assert(viewIndicator.valid, "Could not create view cone");

		viewIndicatorShader = new ViewIndicatorShader();
	}

	this(vec2[] path, float segmentTime)
	{
		this.path = path;
		this.segmentTime = segmentTime;
		iSegmentTime = 1.0f / segmentTime;
		pos = vec2(0, 0);
		tex = new Texture("res/tex/npc.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);
		rect = RectangleShape.create(tex, vec2(0, 0), vec2(64, 64));
		rect.origin = vec2(32, 32);

		viewIndicator = new Mesh();
		viewIndicator.addVertices([vec3(0, 0, 0), vec3(-302.59f, 398.04f, 0), vec3(302.59f, 398.04f, 0)]);
		viewIndicator.addTexCoords([vec2(0, 0), vec2(1, 0), vec2(1, 1)]);
		viewIndicator.addIndices([0, 1, 2]);
		viewIndicator.create();

		assert(viewIndicator.valid, "Could not create view cone");

		viewIndicatorShader = new ViewIndicatorShader();
	}

	vec2 getSegment(int segment)
	{
		while (segment < 0)
			segment += path.length;
		return path[segment % path.length];
	}

	void speak(TTFText spokenText, float time)
	{
		speakTime = time;
		this.spokenText = spokenText;
	}

	void update(float delta)
	{
		time += delta;
		if (time > segmentTime)
		{
			time -= segmentTime;
			segment++;
			segment %= path.length;
		}
		pos = path[segment] * (1 - time * iSegmentTime) + getSegment(segment + 1) * (time * iSegmentTime);
		rotation = -atan2(path[segment].y - getSegment(segment + 1).y, path[segment].x - getSegment(segment + 1).x) - 1.57079633f;
		speakTime -= delta;
		if (speakTime < -1)
			speakTime = -1;
	}

	float sign(vec2 p1, vec2 p2, vec2 p3)
	{
		return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
	}

	bool canSee(vec2 point)
	{
		if ((point - pos).length_squared < 64 * 64)
			return true;

		bool b1, b2, b3;

		vec2 v2 = pos + vec2(sin(rotation - 0.65f) * 500, cos(rotation - 0.65f) * 500);
		vec2 v3 = pos + vec2(sin(rotation + 0.65f) * 500, cos(rotation + 0.65f) * 500);

		b1 = sign(point, pos, v2) < 0.0f;
		b2 = sign(point, v2, v3) < 0.0f;
		b3 = sign(point, v3, pos) < 0.0f;

		return (b1 == b2) && (b2 == b3);
	}

	override void draw(IRenderTarget target, ShaderProgram shader = null)
	{
		matrixStack.push();
		matrixStack.top = matrixStack.top * mat4.identity.rotate2d(-rotation).translate2d(pos.x, pos.y);
		target.draw(viewIndicator, viewIndicatorShader);
		matrixStack.pop();

		rect.position = pos;
		rect.rotation = -rotation + 3.14159265f;
		rect.draw(target, shader);
		if (speakTime > 0)
		{
			spokenText.position = pos - vec2(0, 64);
			spokenText.draw(target, shader);
		}
	}
}
