if(irandom(7)==0){
	switch(irandom(2)){
		// remove
		case 0:
		case 1:
			repeat(10000){
				if(array_length(ids)==0)
					break;
				var i = irandom(array_length(ids)-1);
				p.remove_item(ids[i]);
				array_swap_and_pop(ids, i);
			}
			break;
		// add
		case 2:
			repeat(10000){
				array_push(ids, p.add_item(p.count()));
			}
			break;
	}
}
var pre = p.size();
p.shrink();
show_debug_message($"{pre} -> {p.size()} / {p.count()}")