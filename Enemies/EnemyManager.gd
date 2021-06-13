class_name EnemyManager
extends Node2D


const Enemy = preload("res://Enemies/Enemy.tscn")
const Explosion = preload("res://Effects/Explosion.tscn")


onready var bullet_manager: BulletManager = $"../BulletManager"

onready var paths = {
    "loop": $LoopPath,
    "left_to_right": $LeftToRightPath,
    "left_to_right_diagonal": $LeftToRightDiagonalPath,
    "right_to_left_diagonal": $RightToLeftDiagonalPath,
}

var enemies = []
var frame_num = 0


func on_death(pos: Vector2):
    var effect = Explosion.instance()
    add_child(effect)
    effect.position = pos
    effect.run()


func spawn_enemy_on_path(idx: String):
    var enemy = Enemy.instance()
    enemy.path_idx = idx
    enemy.connect("fire", bullet_manager, "spawn_bullet")
    enemy.connect("death", self, "on_death")
    paths[idx].add_child(enemy)
    enemies.append(enemy)


func _physics_process(_delta: float) -> void:
    frame_num += 1

    if frame_num % (60 * 4) == 0:
        spawn_enemy_on_path("left_to_right")
    if frame_num % (60 * 5) == 0:
        spawn_enemy_on_path("loop")


#### snapshot


func make_snapshot_for_enemy(e):
    return {
        "offset": e.offset,
        "health": e.health,
        "fire_cooldown": e.fire_cooldown,
        "path_idx": e.path_idx,
    }


func restore_snapshot_for_enemy(e, snapshot):
    e.offset = snapshot["offset"]
    e.set_health(snapshot["health"])
    e.fire_cooldown = snapshot["fire_cooldown"]


func make_snapshot():
    var enemies_snapshot = []

    for e in enemies:
        if is_instance_valid(e):
            enemies_snapshot.append(make_snapshot_for_enemy(e))

    return {
        "enemies": enemies_snapshot,
        "frame_num": frame_num,
    }


func restore_snapshot(snapshot):
    frame_num = snapshot["frame_num"]
    for e in snapshot["enemies"]:
        spawn_enemy_on_path(e["path_idx"])
        restore_snapshot_for_enemy(enemies[-1], e)
