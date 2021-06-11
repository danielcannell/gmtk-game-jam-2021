extends Node2D


const Enemy = preload("res://Enemies/Enemy.tscn")


onready var path = $Path2D

var enemy = null


func _ready():
    create_enemies()


func create_enemies() -> void:
    # Test code for now
    enemy = Enemy.instance()
    path.add_child(enemy)



func _physics_process(delta: float) -> void:
    # Test code for now:
    if Input.is_action_just_pressed("timeline"):
        enemy.queue_free()
        create_enemies()

    enemy.run_step(delta)
