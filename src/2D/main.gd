extends Node2D
## This file is part of the program responsible for the 2D physics test
##
## Copyright (c) 2025 Guilherme Nascimento (brcontainer@yahoo.com.br)
##
## Released under the MIT license


const MAX: int = 16

var counter: int = 0
var iterator: Array = range(MAX)
var source: PackedScene = preload("res://src/2D/ball.tscn")

@onready var from: Node2D = $From
@onready var from_x: float = from.global_position.x
@onready var generator_timer: Timer = $GeneratorTimer
@onready var info: Info = $Info


func _on_create_object() -> void:
	for index: int in iterator:
		var node: Node2D = source.instantiate()
		node.position.x = from_x + (index * 45.0)
		add_child(node)

	counter += MAX
	info.set_counter(counter)


func _on_info_finished() -> void:
	generator_timer.stop()

	for node in get_children():
		if node is RigidBody2D:
			node.queue_free()


func _on_info_started() -> void:
	generator_timer.start()


func _ready() -> void:
	info.set_physics(ProjectSettings.get_setting_with_override("physics/2d/physics_engine"))
