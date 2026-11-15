## Scroll bar that stays at the bottom
extends ScrollContainer




func scroll_down() :
	scroll_vertical = int(get_v_scroll_bar().max_value)
