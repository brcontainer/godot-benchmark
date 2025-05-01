class_name Info
extends CanvasLayer
## This file is part of the program, responsible for returning the results.
##
## Copyright (c) 2025 Guilherme Nascimento (brcontainer@yahoo.com.br)
##
## Released under the MIT license


const FPS_START: float = 10.0
const FPS_END: float = 3.0

var enabled: bool = true
var running: bool = false
var is_debug: bool = OS.is_debug_build()
var timer: float

@onready var game_info: Label = %Game
@onready var engine_info: Label = %Engine
@onready var physics_info: Label = %Physics
@onready var counter_info: Label = %Counter
@onready var total_time: Label = %TotalTime
@onready var total_time_layer: CanvasLayer = $TotalTimeLayer
@onready var background_layer: CanvasLayer = $Background

## Indicates that the test should be finished
signal finished

## Indicates that the test should be started
signal started


## Display current physics engine
func set_physics(engine: String) -> void:
	physics_info.text = engine


## Update number objects
func set_counter(number: int) -> void:
	counter_info.text = str(number) + " objects"


func _display_time() -> void:
	timer /= 1000.0

	var hours = timer / 3600.0;
	var minutes = fmod(timer, 3600.0) / 60.0
	var seconds = fmod(timer, 60.0)

	total_time.text = "%02d:%02d:%02d" % [hours, minutes, seconds]

	background_layer.show()
	total_time_layer.show()


func _on_copy_results() -> void:
	var info: String = engine_info.text

	info += "\n" + physics_info.text
	info += "\n" + counter_info.text
	info += "\n" + total_time.text + " elapsed"

	DisplayServer.clipboard_set(info)


func _on_back_to_intro() -> void:
	get_tree().change_scene_to_file("res://src/intro.tscn")


func _process(_delta: float) -> void:
	var fps: float = Engine.get_frames_per_second()

	if not running and fps > FPS_START:
		running = true
		timer = Time.get_ticks_msec()
		started.emit()

	if enabled and running:
		if fps < FPS_END:
			enabled = false
			timer = Time.get_ticks_msec() - timer
			finished.emit()
			_display_time()

		var info: String = "FPS: " + str(fps)

		if is_debug:
			info += "\nMemory: "
			info += String.humanize_size(OS.get_static_memory_usage())
			info += "\nPeak Memory: "
			info += String.humanize_size(OS.get_static_memory_peak_usage())

		game_info.text = info


func _ready() -> void:
	total_time_layer.hide()
	background_layer.hide()

	var driver: String = RenderingServer.get_current_rendering_driver_name()
	var method: String = RenderingServer.get_current_rendering_method()
	var info: String = "Godot: " + Engine.get_version_info().string

	info += "\nRenderer: %s (%s)" % [driver, method]
	info += "\nDevice: " + RenderingServer.get_video_adapter_name()

	engine_info.text = info
