class_name EnemyManager
extends Node2D


const Enemy = preload("res://Enemies/Enemy.tscn")
const Boss = preload("res://Enemies/Boss.tscn")
const Explosion = preload("res://Effects/Explosion.tscn")


onready var bullet_manager: BulletManager = $"../BulletManager"


onready var paths = {
    "loop": $LoopPath,
    "left_to_right": $LeftToRightPath,
    "left_to_right_diagonal": $LeftToRightDiagonalPath,
    "right_to_left_diagonal": $RightToLeftDiagonalPath,
    "boss": $BossPath,
}


var enemies = []
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


func spawn_enemy_on_path(idx: String, enemy_type: int):
    var enemy
    match enemy_type:
        Globals.EnemyType.BASIC:
            enemy = Enemy.instance()
        Globals.EnemyType.BOSS:
            enemy = Boss.instance()

    enemy.path_idx = idx
    enemy.connect("fire", bullet_manager, "spawn_bullet")
    enemy.connect("death", self, "on_death")
    paths[idx].add_child(enemy)
    enemies.append(enemy)


func advance_waves(frame_num: int):
    if wave_idx < len(Globals.WAVES) and !wave_active and frame_num > Globals.WAVES[wave_idx]["start"]:
        wave_active = true
        spawn_timer = 0
        spawn_count = Globals.WAVES[wave_idx]["count"]

    if wave_active:
        if spawn_timer == 0:
            var path = Globals.WAVES[wave_idx]["paths"][path_idx % len(Globals.WAVES[wave_idx]["paths"])]
            var type = Globals.WAVES[wave_idx]["type"]
            spawn_enemy_on_path(path, type)
            if spawn_count % 3 == 0:
                enemies[-1].enemy_shield.set_state(true)
            spawn_timer = Globals.WAVES[wave_idx]["interval"]
            spawn_count -= 1
            path_idx += 1

            if spawn_count == 0:
                wave_idx += 1
                wave_active = false

        spawn_timer -= 1


func run_tick(delta: float, frame_num: int) -> void:
    var queued_for_destruction = []
    for enemy in enemies:
        if enemy.dead:
            queued_for_destruction.append(enemy)
            continue

        enemy.run_tick(delta, frame_num)

    for enemy in queued_for_destruction:
        var idx = enemy.path_idx
        paths[idx].remove_child(enemy)
        enemies.erase(enemy)
        enemy.queue_free()

    advance_waves(frame_num)


#### snapshot


func make_snapshot_for_enemy(e):
    return {
        "offset": e.offset,
        "health": e.health,
        "fire_cooldown": e.fire_cooldown,
        "path_idx": e.path_idx,
        "dead": e.dead,
        "type": e.enemy_type,
        "shield_energy": e.enemy_shield.energy,
    }


func restore_snapshot_for_enemy(e, snapshot):
    e.offset = snapshot["offset"]
    e.set_health(snapshot["health"])
    e.fire_cooldown = snapshot["fire_cooldown"]
    e.dead = snapshot["dead"]
    e.enemy_shield.set_energy(snapshot["shield_energy"])


func make_snapshot():
    var enemies_snapshot = []

    for e in enemies:
        if is_instance_valid(e):
            enemies_snapshot.append(make_snapshot_for_enemy(e))

    return {
        "enemies": enemies_snapshot,
        "wave_idx": wave_idx,
        "wave_active": wave_active,
        "spawn_timer": spawn_timer,
        "spawn_count": spawn_count,
        "path_idx": path_idx,
    }


func restore_snapshot(snapshot):
    wave_idx = snapshot["wave_idx"]
    wave_active = snapshot["wave_active"]
    spawn_timer = snapshot["spawn_timer"]
    spawn_count = snapshot["spawn_count"]
    path_idx = snapshot["path_idx"]

    for e in snapshot["enemies"]:
        spawn_enemy_on_path(e["path_idx"], e["type"])
        restore_snapshot_for_enemy(enemies[-1], e)
