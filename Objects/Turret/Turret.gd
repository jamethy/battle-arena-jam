extends Node2D

var tracking = []

func _ready():
	$WeaponHolster.set_weapon_by_name("PISTOL")
	$WeaponHolster.set_owner_id(-1) # override the network master

func _physics_process(_delta: float):

	# if tracking targets available, find closest and look at it
	if tracking.size() > 0:
		var target := Vector2()
		var target_distance := 100000.0
		for t in tracking:
			var dist = position.distance_squared_to(t.position)
			if dist < target_distance:
				target_distance = dist
				target = t.position
		$WeaponHolster.look_at(target)


func _on_Area2D_body_entered(body:Node):
	tracking.append(body)
	$ShotTimer.start()


func _on_Area2D_body_exited(body:Node):
	tracking.erase(body)
	if tracking.size() == 0:
		$ShotTimer.stop()


func _on_ShotTimer_timeout():
	$WeaponHolster.shoot()
