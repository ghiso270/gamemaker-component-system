sub = new PoolingSubcomponent(3);


print = function(){
	static i = 0;
	++i;
	show_debug_message($"TEST {i}")
	show_debug_message($"items: {sub.__.items}")
	show_debug_message($"free: {sub.__.free_indexes}")
	show_debug_message($"full: {sub.__.full_indexes}")
	show_debug_message($"-----------------------")
}

show_debug_message($"##########################################")
print()
sub.__.items = [1,0,1,0,0,0]
sub.__.free_indexes = [1,3,4,5]
sub.__.full_indexes = [0,2]
print()
sub.shrink()
print()
show_debug_message($"##########################################")

game_end(0)
