extends Node2D

export var playerNumber = 0;
onready var sprite = get_node("AnimatedSprite")
var alive = true
var score = 0

export(NodePath) var scoreBoard
export(Color) var color
export(AudioStream) var shot
export(AudioStream) var miss
onready var speaker = get_node("AudioStreamPlayer2D")
func _ready():
	scoreBoard = get_node(scoreBoard)

func reset():
	print("Reset Player ", playerNumber+1)
	alive = true
	playAnimation("Idle")

func restartGame():
	score =0


func shoot():
	speaker.set_stream(shot)
	
	
	if(sprite.animation == "Die"): speaker.set_stream(miss)
	
	speaker.pitch_scale = rand_range(0.5,1.5)
	speaker.play(0)
	print("Player ",  playerNumber , " Shot")
	if(sprite.animation != "Idle"): return
	playAnimation("Shoot")
	
	
	
func playAnimation(animation = "name"):
	sprite.set_frame(0)
	sprite.play(animation)

func victory(victory = false):
	if(victory) : 
		addPoint()
		
	else:
		playAnimation("Die")
		get_node("Particles2D").restart()
		
		get_node("Particles2D").emitting = true
		speaker.set_stream(miss)
		
	
	

func addPoint():
	score += 1	
	if(score < 5): scoreBoard.addPoint(color)
	if(score > 4): winsGame()
func winsGame():
	print("Player ", playerNumber+1, " WINS!")
	get_node("Victory").restart()
	

func button_pressed():
	shoot()	
	get_tree().root.get_child(0).submitShot(playerNumber)


