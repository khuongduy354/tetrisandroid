extends Node2D
class_name Board

@export var board_rows = 16
@export var board_cols = 10
@onready var anim_p = $AnimationPlayer

var board_width = board_cols * Global.CELL_SIZE
var board_height = board_rows * Global.CELL_SIZE
var still_tiles = []

var game_paused = false


func _ready(): 
	draw_board()
	Events.connect("game_over",func():reset_game())
	Events.connect("to_still",Callable(self,"_on_to_still"))


# main features
func modulate_on(): 
	for child in $BoardTiles.get_children(): 
		child.self_modulate = Color(1,1,1,1)
func modulate_off(): 
	for child in $BoardTiles.get_children(): 
		child.self_modulate = Color(1,1,1,0.1)
func start_game(): 
	spawn_block()

func reset_game(): 
	SfxManager.play(SfxManager.GAMEOVER)
	anim_p.play("modulate_onoff")
	next_block=null
	still_tiles=[]
	for block in $Blocks.get_children(): 
		block.queue_free()
func resume_game(): 
	for block in $Blocks.get_children(): 
		block.set_physics_process(true)
		block.get_node("down_timer").start()
	game_paused=false
func pause_game(): 
	for block in $Blocks.get_children(): 
		block.set_physics_process(false)
		block.get_node("down_timer").stop()
	game_paused = true
		
func draw_board(): 
	for row in range(board_rows): 
		for col in range(board_cols): 
			var pos = map_to_world(Vector2(col, row))
			var tile =  preload("res://Board/board_tile.tscn").instantiate()
			$BoardTiles.add_child(tile)
			tile.global_position = pos
var next_block=null
func pick_block(): 
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
	next_block = node
	Events.next.emit(next_block)
func spawn_block(): 
	if !next_block: 
		pick_block()
	$Blocks.add_child(next_block)
	next_block.global_position = $spawn_pos.global_position
	next_block = null
	pick_block()
# checkers 
func check_fail(): 
	for x in range(board_cols): 
		var pos = Vector2(x,0)
		if tile_in_list(pos):
			Events.game_over.emit()
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

func check_tile_colliding_rotation(blocktiles,deg):
	blocktiles.rotate(deg_to_rad(deg))
	blocktiles.rotation_degrees=fmod(blocktiles.rotation_degrees,360)
	for tile in blocktiles.get_children(): 
		# check border 
		var test_pos = map_to_board(tile.global_position)

		
		# check collide rotation 
		if tile_in_list(map_to_board(tile.global_position)) or is_border(test_pos): 
			blocktiles.rotate(deg_to_rad(-deg))
			return true
	return false


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
				remove_still_tile(Vector2(x,y))
				for block in $Blocks.get_children():
					block.clear_tile(Vector2(x,y))
		SfxManager.play(SfxManager.CLEAR)
	# shift
		for i in range(lines_cleared_list.size()):
			var base_line = lines_cleared_list[i] 
			for block in $Blocks.get_children(): 
				block.drop_tile(base_line)
		
	# scores based on lines 
		var score = 0 
		match length: 
			1: 
				score =100
			2: 
				score = 300
			3: 
				score = 500
			4: 
				score = 800
		Events.scored.emit(score)
# helpers
func map_to_board(coor:Vector2): 
	coor-=global_position
	var board_pos = (coor-Vector2(Global.HALF_CELLSIZE, Global.HALF_CELLSIZE))/Global.CELL_SIZE
	return Vector2(roundi(board_pos.x),roundi(board_pos.y))
	
func map_to_world(coor:Vector2): 
	var world_pos = coor * Global.CELL_SIZE+Vector2(Global.HALF_CELLSIZE,Global.HALF_CELLSIZE)
	return world_pos+global_position
func is_border(test_pos): 
	if test_pos.y >= board_rows or test_pos.x < 0 or test_pos.x >= board_cols: 
		return true
	return false
func tile_in_list(pos): 
	for still_tile in still_tiles: 
		var still_pos = map_to_board(still_tile.global_position)
		if still_pos == pos: 
			return true
	return false
func remove_still_tile(tile_pos): 
	for i in range(still_tiles.size()): 
		var still_tile = still_tiles[i]
		if map_to_board(still_tile.global_position) == tile_pos: 
			still_tiles.remove_at(i)
			return
func print_still_board(): 
	var result = []
	for tile in still_tiles: 
		var pos = map_to_board(tile.global_position)
		result.push_back(pos)
	print("STILL BOARD",result)
# handlers 
func _on_to_still(tiles): 
	for tile in tiles.get_children(): 
		still_tiles.push_back(tile)
	check_lines(tiles)
	Events.scored.emit(10)
	if check_fail(): 
		return
	spawn_block()


func _on_animation_player_animation_finished(anim_name):
	if anim_name =="modulate_onoff":
		start_game()
