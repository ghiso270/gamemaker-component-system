var str = input.check(true)
if(keyboard_check(ord("A"))){
	t.restart_chronometer(chron);
}
draw_text(200, 100, $"input: {str}")
draw_text(200, 200, $"buffer: {input.__.buffers[0]}")
draw_text(200, 300, $"chron: {t.check_chronometer(chron)}")