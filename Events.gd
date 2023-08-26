extends Node

# warnings-disable

# Global Events Bus

# all signals accept an object of arguments since gdscript does not support variadic arguments
# net_id
signal player_disconnected(dict)
# net_id, data
signal player_spawned(dict)
# player_id, transform, max_range, speed, precision, count
signal player_fired_bullet(dict)
# player_id, damage, damage_doer
signal player_hit_by_bullet(dict)
# player_id, value, max_value
signal player_health_change(dict)
# player_id, killer_id
signal player_died(dict)
# player_id, value, max_value
signal	player_action_change(dict)
# player_id,item_name
signal	player_item_pickup(dict)	

func emit(signal_name: String, args: Dictionary = {}):
	rpc("_emit_signal", signal_name, args)

func local_emit(signal_name: String, args: Dictionary = {}):
	log_signal(signal_name, "local", args)
	emit_signal(signal_name, args)

remotesync func _emit_signal(signal_name: String, args: Dictionary):
	log_signal(signal_name, "remote", args)
	emit_signal(signal_name, args)

func log_signal(signal_name: String, type: String, args: Dictionary):
	print("signal(%s): %s " % [type, signal_name], args)
	
