extends Node2D


onready var cone = $Cone
onready var smoke = $Smoke
onready var scaler = $Scaler

# Declare member variables here. Examples:
var height = 80;


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func set_thrust(t):
    scaler.scale.y = t



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
