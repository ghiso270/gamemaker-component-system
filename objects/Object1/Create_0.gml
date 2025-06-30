man = new ComponentManager(id)

man.set_component("health", new Component([[ev_step, ev_step_normal], [ev_step, ev_step_begin]]));
man.set_component("a", new Component([[ev_create, ev_create], [ev_step, ev_step_begin]]));

man.destroy()
