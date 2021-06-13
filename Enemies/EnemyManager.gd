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


const WAVES = [
    {
        "start": 2 * 60,
        "paths": ["left_to_right"],
        "count": 5,
        "interval": 60,
    },
    {
        "start": 15 * 60,
        "paths": ["left_to_right_diagonal", "right_to_left_diagonal"],
        "count": 10,
        "interval": 60,
    },
    {
        "start": 30 * 60,
        "paths": ["loop"],
        "count": 20,
        "interval": 30,
    }
]


var enemies = []
var frame_num := 0
var wave_idx := 0
var wave_active := false
var spawn_timer := 0
var spawn_count := 0
var path_idx := 0


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


func advance_waves():
    if wave_idx < len(WAVES) and !wave_active and frame_num > WAVES[wave_idx]["start"]:
        wave_active = true
        spawn_timer = 0
        spawn_count = WAVES[wave_idx]["count"]

    if wave_active:
        if spawn_timer == 0:
            spawn_enemy_on_path(WAVES[wave_idx]["paths"][path_idx % len(WAVES[wave_idx]["paths"])])
            spawn_timer = WAVES[wave_idx]["interval"]
            spawn_count -= 1
            path_idx += 1

            if spawn_count == 0:
                wave_idx += 1
                wave_active = false

        spawn_timer -= 1


func _physics_process(_delta: float) -> void:
    frame_num += 1
    advance_waves()


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
        "wave_idx": wave_idx,
        "wave_active": wave_active,
        "spawn_timer": spawn_timer,
        "spawn_count": spawn_count,
        "path_idx": path_idx,
    }


func restore_snapshot(snapshot):
    frame_num = snapshot["frame_num"]
    wave_idx = snapshot["wave_idx"]
    wave_active = snapshot["wave_active"]
    spawn_timer = snapshot["spawn_timer"]
    spawn_count = snapshot["spawn_count"]
    path_idx = snapshot["path_idx"]

    for e in snapshot["enemies"]:
        spawn_enemy_on_path(e["path_idx"])
        restore_snapshot_for_enemy(enemies[-1], e)
