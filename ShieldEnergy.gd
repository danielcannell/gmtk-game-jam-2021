extends Node2D

onready var black_bar := $BlackBar
onready var blue_bar := $BlueBar


func set_fraction(fraction: float) -> void:
    blue_bar.rect_size.x = fraction * black_bar.rect_size.x

    var damaged = (fraction < 0.99)
    blue_bar.visible = damaged
    black_bar.visible = damaged


func _ready() -> void:
    set_fraction(0.0)
