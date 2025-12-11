sub = new PoolingSubcomponent();

sub.__.items = [1, 0, 1, 1, 1, 0]
sub.__.free_indexes = [1, 5]

show_debug_message($"##########################################")
show_debug_message($"TEST A = {sub.shrink()}")
sub.__.items = [1, 1, 0, 1, 0, 1]
sub.__.free_indexes = [2, 4]
show_debug_message($"TEST B = {sub.shrink()}")
sub.__.items = [0, 0, 0, 1]
sub.__.free_indexes = [0,1,2]
show_debug_message($"TEST C = {sub.shrink()}")
show_debug_message($"##########################################")