@tool
extends Node3D

@export var floor_visible : bool = true:
	set(value):
		floor_visible = value
		if is_inside_tree():
			_update_floor_visible()


func _update_floor_visible():
	# Only make floor (in)visible, collision stays active
	$Floor/MeshInstance3D.visible = floor_visible


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_floor_visible()
