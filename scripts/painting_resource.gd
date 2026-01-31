class_name PaintingResource extends Resource

@export var colors: Array[Color]

func create_from_grid(grid_buttons: Array):
	colors.resize(grid_buttons.size())
	for i in range(grid_buttons.size()):
		colors[i] = grid_buttons[i].modulate
		
func load_to_grid(grid_buttons: Array):
	for i in range(grid_buttons.size()):
		grid_buttons[i].modulate = colors[i]
