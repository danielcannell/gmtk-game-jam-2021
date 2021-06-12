extends Node2D


onready var cone = $"Scaler/Cone"
onready var smoke = $"Scaler/Smoke"
onready var scaler = $Scaler
onready var trail: Particles2D = $"Scaler/Trail"

# Declare member variables here. Examples:
var height = 80;
var bend = 0;
var init_vel = 800;


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func set_mod(x):
    cone.self_modulate.a = x

func set_thrust(t):
    scaler.scale.y = t

func set_trail_bend(t):
    if t != bend:
        trail.process_material.set("tangential_accel", t);
        trail.restart()
    bend = t



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
