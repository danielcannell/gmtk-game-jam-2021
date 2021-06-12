extends Node2D


const Enemy = preload("res://Enemies/Enemy.tscn")
const Explosion = preload("res://Effects/Explosion.tscn")


onready var loop_path = $LoopPath
onready var across_path = $AcrossPath
onready var bullet_manager: BulletManager = $"../BulletManager"


var enemies = []
var frame_num = 0

func on_death(pos):
    var effect = Explosion.instance()
    add_child(effect)
    effect.position = pos
    effect.run()


func spawn_enemy_on_path(path):
    var enemy = Enemy.instance()
    enemy.connect("fire", bullet_manager, "spawn_bullet")
    enemy.connect("death", self, "on_death")
    path.add_child(enemy)
    enemies.append(enemy)


func _physics_process(_delta: float) -> void:
    # Test code for now:
    if Input.is_action_just_pressed("timeline"):
        for enemy in enemies:
            if is_instance_valid(enemy):
                enemy.queue_free()

        enemies = []

        frame_num = 0

    frame_num += 1

    if frame_num % (60 * 4) == 0:
        spawn_enemy_on_path(across_path)
    if frame_num % (60 * 5) == 0:
        spawn_enemy_on_path(loop_path)
