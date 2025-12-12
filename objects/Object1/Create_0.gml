sub = new PoolingSubcomponent();

print = function(){
	static i = 0;
	++i;
	show_debug_message($"TEST {i}")
	show_debug_message($"items: {sub.__.items}")
	show_debug_message($"free: {sub.__.free_indexes}")
	show_debug_message($"-----------------------")
}

show_debug_message($"##########################################")
sub.__.items = [1, 0, 1, 1, 1, 0]
sub.__.free_indexes = [1, 5]
print()

sub = new PoolingSubcomponent();
sub.add_item(1)
sub.add_item(2)
sub.add_item(3)
sub.add_item(4)
sub.add_item(5)
sub.add_item(6)
show_debug_message(sub.remove_item(0))
show_debug_message(sub.remove_item(1))
show_debug_message(sub.remove_item(2))
show_debug_message(sub.remove_item(3))
show_debug_message(sub.remove_item(4))
show_debug_message(sub.remove_item(5))
print()
sub.shrink()
print()
show_debug_message($"##########################################")

game_end(0)
