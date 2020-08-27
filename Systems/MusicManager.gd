"""
Plays a song and sends signal when the input window starts
and stops. 
after the input period a signal with the input is
sent. 
if there is an player input outside the input window, a
failure signal is sent.
"""

extends Spatial
class_name BeatManager

onready var player = $AudioStreamPlayer

enum { WAIT, INPUT_ON, INPUT_OFF }
var state: int

var offset: float = 0.0
var bpm: float = 100
var beat: float = 60 / bpm
var beat_offset = beat * 0.25

var time_elapsed: float = 0

var time_start: float = 0
var time_since_last_beat: float = 0
var beat_count: int = 1

var current_beat_input: InputEvent = null

signal beat_input_started
signal beat_input_ended

signal beat_input
signal mistimed_input


func _ready() -> void:
	state = WAIT
	Refs.beat_manager = self
	
func start() -> void:
	player.play(offset)
	beat_count = 1
	state = INPUT_OFF
	time_elapsed = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dance_up") or event.is_action_pressed("dance_down") or event.is_action_pressed("dance_left") or event.is_action_pressed("dance_right"):
		if state == INPUT_OFF:
			emit_signal("mistimed_input", event)
		elif state == INPUT_ON and current_beat_input == null:
			current_beat_input = event

func process_input_on(delta: float) -> void:
	if time_elapsed >= beat * beat_count + beat_offset:
		emit_signal("beat_input_ended")
		emit_signal("beat_input", current_beat_input)
		current_beat_input = null
		state = INPUT_OFF
		beat_count += 1
	
	
func process_input_off(delta: float) -> void:
	if time_elapsed >= beat * beat_count - beat_offset:
		emit_signal("beat_input_started")
		state = INPUT_ON


func _process(delta: float) -> void:
	time_elapsed = player.get_playback_position()
	
	match state:
		INPUT_ON: process_input_on(delta)
		INPUT_OFF: process_input_off(delta)


func _on_AudioStreamPlayer_finished() -> void:
	print("restart loop")
	start()
