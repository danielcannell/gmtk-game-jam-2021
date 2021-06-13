extends Node2D

onready var label = $Label
onready var tween = $Tween
onready var timeline_manager = $TimelineManager
onready var enemy_manager = $EnemyManager


func show_message(text: String):
    label.text = text
    label.visible = true
    tween.interpolate_property(label, "modulate:a", 0, 1, 0.1)
    tween.start()
    yield(tween, "tween_completed")
    yield(get_tree().create_timer(2), "timeout")
    tween.interpolate_property(label, "modulate:a", 1, 0, 0.5)
    tween.start()
    yield(tween, "tween_completed")
    label.visible = false


func _ready():
    $BulletManager.set_bounding_box(get_viewport_rect().grow(16))
    timeline_manager.connect("display_message", self, "show_message")
    enemy_manager.connect("display_message", self, "show_message")
