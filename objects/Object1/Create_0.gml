man = new ComponentManager(self);
man.add_component(new Component("health", [[ev_step, ev_step_normal], [ev_create, ev_create]]));
man.add_component(new Component("health", [[ev_step, ev_step_normal], [ev_step, ev_step_begin]]));
man.add_component(new Component("cum", [[ev_step, ev_step_normal], [ev_create, ev_create]]));

show_debug_message(string(man));