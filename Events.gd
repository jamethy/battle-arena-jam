extends Node

# Global Events Bus

# all signals accept an object of arguments since gdscript does not support variadic arguments
signal player_spawned(dict)
signal player_fired_bullet(dict)
signal player_hit_by_bullet(dict)


func emit(signal_name: String, args: Dictionary = {}):
	rpc("_emit_signal", signal_name, args)

func local_emit(signal_name: String, args: Dictionary = {}):
	print("signal(local): "  + signal_name)
	emit_signal(signal_name, args)

remotesync func _emit_signal(signal_name: String, args: Dictionary):
	print("signal(remote): "  + signal_name)
	emit_signal(signal_name, args)
