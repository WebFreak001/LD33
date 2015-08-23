module game.collectable;

import d2d;

enum CollectableItems : int
{
	SandwichBottom = 1000,
	Sandwich,
	SandwichBread,
	Plank,
	Nail,
	String,
	Axe,
	Stick,
	Bottle,
	Glove,
	Salt,
	Cat
}

class Collectable
{
	RectangleShape rect;
	float stealWorth;
	int id;

	this(Texture items, float worth, vec2 pos, vec4 uv, int id)
	{
		rect = RectangleShape.create(items, pos, vec2(64, 64), uv);
		stealWorth = worth;
		this.id = id;
	}
}
