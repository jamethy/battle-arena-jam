extends Area2D
tool

onready var _set_spawn_point := $SpawnPoint
onready var _antimation := $AnimationPlayer
onready var _interaction_zone :=$InteractionZone

export var item_scene: PackedScene setget set_item

var item: Item
puppet var puppetTransform: Transform2D

func _ready():
	set_item(item_scene)
	_antimation.play("Idle")

func set_item(scene: PackedScene) -> void:
	item_scene = scene
	if item:
		item.queue_free()

	if not is_inside_tree():
		yield(self,"ready")

	for child in _set_spawn_point.get_children():
		_set_spawn_point.remove_child(child)

	if item_scene:
		var new_item = scene.instance()
		assert(new_item is Item, "not a item")

		item = new_item
		item.set_network_master(get_network_master())
		_set_spawn_point.add_child(item)

func interact():
	queue_free()
	Events.emit("player_item_pickup", {
		"player_id": int(1), #HACKED TO ADD NOT SURE HOW TO IDENTIFY THE CORRECT PLAYER IS
		"item_name": String(item.item_name),
	})

func _on_WorldItem_body_entered(body):
	interact()
