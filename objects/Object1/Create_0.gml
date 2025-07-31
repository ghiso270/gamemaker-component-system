global.game_pause = false;
global.game_speed = 1;
var input = new MovementInputSubcomponent("W", "A", "S", "D");
m1 = new MovementComponent("1", 100, 100, input)
m2 = new DummyComponent("2")
m3 = new DummyComponent("3")

man = new ComponentManager(self, [m1,m2,m3]);
man.execute();

