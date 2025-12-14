man = new ComponentManager(self);
t = new TimeComponent("time", []);
t.set_game_speed(3);
chron = t.add_chronometer();
input = new InputSubcomponent("A", t, 5000);
man.add_component(t);

man.execute();