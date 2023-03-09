extends Panel

func _ready():
	Events.connect("player_hit_by_bullet", self, "_on_player_hit_by_bullet")

func  _on_player_hit_by_bullet(params: Dictionary):
	if params.player_id != get_tree().get_network_unique_id():
		# not for this player
		return
	show()
	$Timer.start()

func _on_Timer_timeout():
	hide()
