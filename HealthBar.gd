extends Node2D

onready var red_bar := $RedBar
onready var green_bar := $GreenBar


func set_fraction(fraction: float) -> void:
    green_bar.rect_size.x = fraction * red_bar.rect_size.x

    var damaged = (fraction < 0.99)
    green_bar.visible = damaged
    red_bar.visible = damaged


func _ready() -> void:
    set_fraction(1.0)
