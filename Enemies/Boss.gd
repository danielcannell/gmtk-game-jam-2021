extends PathFollow2D


const SPEED = 50
const MAX_HP = 10000.0

onready var health_bar: Node2D = $HealthBar
onready var area: Area2D = $Area2D
onready var sprite = $Sprite
onready var bullet_manager: BulletManager = $"../../../BulletManager"
onready var tween = $Tween
onready var enemy_shield = $EnemyShield

var health := MAX_HP
var fire_cooldown := 0
var path_idx := ""
var dead := false
var enemy_type: int = Globals.EnemyType.BOSS


signal fire(position, velocity)
signal death(position)


const FIRE_VECTOR := Vector2(0, 1)
const FIRE_SPEED := 300.0
const FIRE_COOLDOWN := 120
const NUM_BULLETS_IN_BARAGE := 20


func _ready():
    # For now all enemies make one pass along their track
    loop = false
    area.connect("area_shape_entered", self, "_on_area_shape_entered")


func should_fire(frame_num: int):
    var fast = (frame_num % (10 * 60)) < 30

    if fast:
        return frame_num % 6 == 0
    else:
        return frame_num % FIRE_COOLDOWN == 0


func fire(frame_num: int):
    # Change the angle each time to stop you finding a safe spot
    var offset := 0.4 * float(frame_num)

    for i in NUM_BULLETS_IN_BARAGE:
        var fire_angle = offset + 2.0 * 3.1415 * i / NUM_BULLETS_IN_BARAGE
        var vec = FIRE_VECTOR.rotated(fire_angle)
        emit_signal("fire", global_position, vec * FIRE_SPEED, false, Bullet.BulletType.NORMAL)


func run_tick(delta: float, frame_num: int) -> void:
    offset += SPEED * delta

    if unit_offset > 1.0:
        offset = 1.0

    if should_fire(frame_num):
        fire(frame_num)

    if health <= 0:
        emit_signal("death", global_position)
        dead = true

    if frame_num % (60 * 5) == 0:
        enemy_shield.set_energy(10000)

    enemy_shield.run_tick()


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    var bullet = bullet_manager.get_bullet(area_shape)

    if bullet.is_player and bullet.type == Bullet.BulletType.NORMAL:
        bullet.dead = true
        set_health(health - bullet.damage)
        damage_effect()


func set_health(new_health: float) -> void:
    health = new_health
    health_bar.set_fraction(health / MAX_HP)


func damage_effect() -> void:
    if not tween.is_active():
        var s= Color(1,1,1,1)
        var e= Color(6,6,6,6)
        tween.interpolate_property(sprite, "modulate",
                s, e, 0.05)
        tween.start()
        yield(tween, "tween_completed")
        tween.interpolate_property(sprite, "modulate",
                e, s, 0.05)
        tween.start()
