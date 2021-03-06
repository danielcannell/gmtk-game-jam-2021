extends PathFollow2D


const SPEED = 200
const MAX_HP = 100.0

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
var enemy_type: int = Globals.EnemyType.BASIC


signal fire(position, velocity)
signal death(position)


const FIRE_VECTOR = Vector2(0, 1)
const FIRE_SPEED = 300.0
const FIRE_COOLDOWN = 70


func _ready():
    # For now all enemies make one pass along their track
    loop = false
    area.connect("area_shape_entered", self, "_on_area_shape_entered")


func run_tick(delta: float, _frame_num: int) -> void:
    offset += SPEED * delta

    if unit_offset > 0.99:
        dead = true
        return

    if fire_cooldown == 0:
        for i in [-20, 0, 20]:
            var vec = FIRE_VECTOR.rotated(deg2rad(i))
            emit_signal("fire", global_position, vec * FIRE_SPEED, false, Bullet.BulletType.NORMAL)
        fire_cooldown = FIRE_COOLDOWN

    if fire_cooldown > 0:
        fire_cooldown -= 1

    if health <= 0:
        emit_signal("death", global_position)
        dead = true

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
