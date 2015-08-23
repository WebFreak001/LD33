module game.groupmember;

import d2d;

import game.player;
import game.npc;
import std.random;

class GroupMember : NPC
{
	Player follow;
	float followTime = -1;
	float targetRotation = 0;
	bool walkTarget = false;

	this(Player follow)
	{
		super();
		this.follow = follow;
		pos = vec2(follow.x, follow.y);
		tex = new Texture("res/tex/group.png", TextureFilterMode.Nearest, TextureFilterMode.Nearest);
		rect = RectangleShape.create(tex, vec2(0, 0), vec2(64, 64));
		rect.origin = vec2(32, 32);
	}

	override void update(float delta)
	{
		speakTime -= delta;
		if (speakTime < -1)
			speakTime = -1;

		if (uniform(0, 10) == 0 && (vec2(follow.x, follow.y) - pos).length_squared > 400 * 400)
			followTime += 0.3f;

		if (followTime > 0)
		{
			if ((vec2(follow.x, follow.y) - pos).length_squared < 100 * 100)
				followTime = 0;
			float direction = atan2(follow.x - pos.x, follow.y - pos.y);
			rotation = direction;
			pos += vec2(sin(direction), cos(direction)) * 2;
			followTime -= delta;
		}
		else if (uniform(0, 160) == 0 && !walkTarget)
		{
			walkTarget = true;
			targetRotation = uniform(-3.1415926f, 3.1415926f);
			rotation = targetRotation;
		}
		else if (walkTarget)
		{
			pos += vec2(sin(targetRotation), cos(targetRotation)) * 2;
			if (uniform(0, 80) == 0)
				walkTarget = false;
		}
	}
}
