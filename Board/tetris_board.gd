extends Node2D
class_name Board

@export var board_rows = 14
@export var board_cols = 10
var board_width = board_cols * Global.CELL_SIZE
var board_height = board_rows * Global.CELL_SIZE
var still_tiles = []


func map_to_board(coor:Vector2): 
	coor-=global_position
	var board_pos = (coor-Vector2(Global.HALF_CELLSIZE, Global.HALF_CELLSIZE))/Global.CELL_SIZE
	return Vector2(int(board_pos.x),int(board_pos.y))
	
func map_to_world(coor:Vector2): 
	var world_pos = coor * Global.CELL_SIZE+Vector2(Global.HALF_CELLSIZE,Global.HALF_CELLSIZE)
	return world_pos+global_position

func _ready(): 
	draw_board()
	spawn_block()
	Events.connect("to_still",Callable(self,"_on_to_still"))
func is_border(test_pos): 
	if test_pos.y >= board_rows or test_pos.x < 0 or test_pos.x >= board_cols: 
		return true
	return false
func check_colliding(tile,additional_pos): 
	var test_pos = map_to_board(tile.global_position)+additional_pos
	
	# check border 
	if is_border(test_pos):
		return true

	for still_tile in still_tiles: 
		var still_pos = map_to_board(still_tile.global_position)
		if still_pos == test_pos: 
			return true
			
	return false
var rotated_pos=[]
func tile_in_list(pos): 
	for still_tile in still_tiles: 
		var still_pos = map_to_board(still_tile.global_position)
		if still_pos == pos: 
			return true
	return false
func check_tile_colliding_rotation(blocktiles,deg):
#	blocktiles.rotate(deg_to_rad(deg))
	blocktiles.rotation_degrees+=deg

	blocktiles.rotation_degrees=fmod(blocktiles.rotation_degrees,360)
	for tile in blocktiles.get_children(): 
		# check border 
		var test_pos = map_to_board(tile.global_position)

		
		# check collide rotation 
		if tile_in_list(map_to_board(tile.global_position)) or is_border(test_pos): 
			blocktiles.rotation_degrees-=deg
			return true
	return false

func remove_still_tile(tile): 
	for i in range(still_tiles.size()): 
		var still_tile = still_tiles[i]
		if still_tile == tile: 
			still_tiles.remove_at(i)
			return
func check_lines(blocktiles): 
	# get all lines
	var lines_cleared_list = []
	for y in range(0,board_rows): 
		var line_cleared =true
		for x in range(0,board_cols):
			if !tile_in_list(Vector2(x,y)):
				line_cleared=false
		if line_cleared: 
			lines_cleared_list.push_back(y)
	
	var length = lines_cleared_list.size()
	if length>0:
	# clear lines	
		for y in lines_cleared_list: 
			for x in range(0,board_cols): 
				for block in $Blocks.get_children():
					var tile = block.clear_tile(Vector2(x,y))
					remove_still_tile(tile)
	# shift
		for i in range(lines_cleared_list.size()):
			var base_line = lines_cleared_list[i] 
			for block in $Blocks.get_children(): 
				block.drop_tile(base_line)
#
#		emit_signal("clear_line",lines_cleared_list.size())


	
func _on_to_still(tiles): 
	for tile in tiles.get_children(): 
		still_tiles.push_back(tile)
	check_lines(tiles)
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
	$Blocks.add_child(node)
	node.global_position = $spawn_pos.global_position
func draw_board(): 
	for row in range(board_rows): 
		for col in range(board_cols): 
			var pos = map_to_world(Vector2(col, row))
			var tile =  preload("res://Board/board_tile.tscn").instantiate()
			add_child(tile)
			tile.global_position = pos+position
