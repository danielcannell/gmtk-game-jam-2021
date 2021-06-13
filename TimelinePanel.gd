extends Control


onready var start_button = $VBoxContainer/TimelineButton
onready var delete_button = $VBoxContainer/Button


signal start()
signal delete_timeline()


var snapshot = null
var idx: int = 0

func _ready():
    start_button.connect("pressed", self, "_on_start_pressed")
    delete_button.connect("pressed", self, "_on_delete_pressed")


func post_init():
    start_button.set_snapshot(snapshot, idx)
    start_button.post_init()


func set_snapshot(ss, i: int) -> void:
    snapshot = ss
    idx = i


func _on_start_pressed() -> void:
    emit_signal("start")


func _on_delete_pressed() -> void:
    emit_signal("delete_timeline")
