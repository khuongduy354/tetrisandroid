extends Node2D
enum{
	MOVEMENT, 
	DROP,
	CLICK, 
	GAMEOVER,
	CLEAR
}
func play(eff): 
	match eff: 
		MOVEMENT: 
			$move.play()
		DROP: 
			$drop.play()
		CLICK: 
			$click.play()
		GAMEOVER: 
			$gameover.play()
		CLEAR: 
			$clear.play()
