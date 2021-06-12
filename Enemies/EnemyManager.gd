extends Node2D


const Enemy = preload("res://Enemies/Enemy.tscn")


onready var path = $Path2D


var enemies = []
var frame_num = 0


func _physics_process(_delta: float) -> void:
    # Test code for now:
    if Input.is_action_just_pressed("timeline"):
        for enemy in enemies:
            if is_instance_valid(enemy):
                enemy.queue_free()

        enemies = []

        frame_num = 0

    frame_num += 1

    if frame_num % 120 == 0:
        var enemy = Enemy.instance()
        path.add_child(enemy)
        enemies.append(enemy)
