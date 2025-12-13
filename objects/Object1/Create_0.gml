var s = {a: 69};
var a;
var callback = function(){
	a = 104;
}
s.f = callback;

show_debug_message($"##########################################")
s.f()
show_debug_message(self)
show_debug_message(s)

show_debug_message($"##########################################")

game_end(0)
