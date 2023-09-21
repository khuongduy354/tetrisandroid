extends Node2D
class_name Board

@export var board_rows = 14
@export var board_cols = 10
var board_width = board_cols * Global.CELL_SIZE
var board_height = board_rows * Global.CELL_SIZE
var still_tiles = []

func map_to_board(coor:Vector2): 
	var board_pos = (coor-Vector2(Global.HALF_CELLSIZE, Global.HALF_CELLSIZE))/Global.CELL_SIZE
	return Vector2(floor(board_pos.x),floor(board_pos.y))
	
func map_to_world(coor:Vector2): 
	var world_pos = coor * Global.CELL_SIZE+Vector2(Global.HALF_CELLSIZE,Global.HALF_CELLSIZE)
	return world_pos

func _ready(): 
	draw_board()
	spawn_block()
	Events.connect("to_still",Callable(self,"_on_to_still"))

func check_colliding(tile,additional_pos): 
	var test_pos = map_to_board(tile.global_position)+additional_pos
	
	# check border 
	if test_pos.y >= board_rows or test_pos.x < 0 or test_pos.x >= board_cols: 
		return true
	for still_tile in still_tiles: 
		var still_pos = map_to_board(still_tile.global_position)
		if still_pos == test_pos: 
			return true
	return false

func _on_to_still(tiles): 
	for tile in tiles.get_children(): 
		still_tiles.push_back(tile)
	spawn_block()
func spawn_block(): 
	var i = randi()%7
	var scene =""
	match i: 
		0: 
			scene = "res://Block/c_block.tscn"
		1: 
			scene = "res://Block/i_block.tscn"
		2: 
			scene = "res://Block/j_block.tscn"
		3: 
			scene = "res://Block/l_block.tscn"
		4: 
			scene = "res://Block/s_block.tscn"
		5: 
			scene = "res://Block/t_block.tscn"
		6: 
			scene = "res://Block/z_block.tscn"
	var node = load(scene).instantiate() 
	node._initialize(self)
	add_child(node)
	node.global_position = $spawn_pos.global_position
func draw_board(): 
	for row in range(board_rows): 
		for col in range(board_cols): 
			var pos = map_to_world(Vector2(col, row))
			var tile =  preload("res://Board/board_tile.tscn").instantiate()
			add_child(tile)
			tile.global_position = pos+position
