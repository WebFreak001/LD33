module game.scene;

import d2d;

alias NextFunc = void delegate(Scene);

class Scene
{
	NextFunc next;

	abstract void dispose();
	abstract void load();
	abstract void onEvent(Event event);
	abstract void update(float delta);
	abstract void draw(IRenderTarget target);
}
