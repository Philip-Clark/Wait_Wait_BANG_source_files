extends Control


var winningShot = false
var enableControls = true

export var players = [] 
export var dots = []


func getGameWinner():
	var winner = null
	for player in players:
		player = get_node(player)
		if(player.score > 4): winner = player
	print(winner)
	return winner


func checkIfFirstTooShoot(id = 0):
	if(!winningShot) : return false
	winningShot = false
	return true

func submitShot(id = 0):
	if(!enableControls) : return
	enableControls = false
	
	var won = checkIfFirstTooShoot(id)
	var tempPlayers = players.duplicate(true)
	var winner = get_node(tempPlayers.pop_at(id))
	var loser = get_node(tempPlayers.front())
	
	get_node("CountDown").visible = false
	
	if(won) : 
		winner.victory(true)
		loser.victory(false)
	else:
		winner.victory(false)
		loser.victory(true)
		
	if(winner.score < 5 and loser.score < 5):
		get_node("ColorRect").modulate = Color(1,1,1)
		wait(2,"wipe")
	else:
		get_node("scores/dot5/winningDot").modulate = getGameWinner().color
		get_node("Restart").disabled = false
		get_node("Restart").visible = true

func wipe():
	get_node("AnimationPlayer").play("wipe")
	reset()
	wait(3,"startCountDown")
	
	
func reset(): 

	for player in players: 
		get_node(player).reset()
		
	winningShot = false
	count = 4	
	
	enableControls = true
	


func wait(time = 10, callback = ""):
	yield(get_tree().create_timer(time,true), "timeout")
	call(callback)

	
func _process(delta):
	if Input.is_key_pressed(KEY_A): get_node(players[0]).button_pressed()
	if Input.is_key_pressed(KEY_L): get_node(players[1]).button_pressed()

	

var count = 4
func startCountDown():

	
	count -= 1;	
	count = 0 if count < 1 else count
	
	if(count == 3): get_node("CountDown").visible = true
	get_node("CountDown").set_text(str(count))
	get_node("CountDown").modulate = Color("#555555")
	
	if(count == 0 and !winningShot): 
		winningShot = true;
		get_node("CountDown").set_text("BANG")
		get_node("CountDown").modulate = Color("#ffcb4f")
		
	else: 
		wait(rand_range(1,3),"startCountDown")
		
			

func _restart_game():
	get_tree().reload_current_scene()
	

func _on_Play_pressed():
	get_node("Container/Player button 1").disabled = false
	get_node("Container/Player button 2").disabled = false
	startCountDown()
	get_node("Play").disabled = true
	get_node("Play").visible = false
