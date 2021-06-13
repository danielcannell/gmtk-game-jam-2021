extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
onready var tween = $Tween
onready var p1: Particles2D = $Particles2D;

var _is_dissolving = false
var burn_duration = 4.0;
var _time = 0.0;


# Called when the node enters the scene tree for the first time.
func _ready():
    sprite.visible = false
    pass # Replace with function body.


func _process(delta):
    if _is_dissolving:
        _time += delta;
        sprite.material.set_shader_param("burn_position", _time / burn_duration )
        if _time > burn_duration:
            _is_dissolving = false
            queue_free()


func run(ship_type: int):
    sprite.set_frame(ship_type)
    _is_dissolving = true
    p1.emitting = true
    sprite.visible = true
