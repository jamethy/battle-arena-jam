extends Label

var weapon: Weapon
export var weapon_scene : PackedScene setget set_scene

func set_scene(scene:PackedScene) -> void:
	weapon_scene = scene
	if weapon:
		weapon.queue_free()
		
	if not is_inside_tree():
		yield(self,"ready")
	
	if weapon_scene:
		var new_weapon = scene.instance()
		assert(new_weapon is Weapon, "not a weapon")
		
		weapon = new_weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
#	self.text = Weapon.weapon_name
