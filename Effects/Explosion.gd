extends Node2D


onready var p1: Particles2D = $Particles;
onready var p2: Particles2D = $Particles2;


# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    # p1.one_shot = true
    # p1.emitting = false


func run():
    p1.emitting = true
    p2.emitting = true
    yield(get_tree().create_timer(4.0), "timeout")
    queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
