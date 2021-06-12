extends PathFollow2D


const SPEED = 200
const MAX_HP = 100.0

onready var health_bar: Node2D = $HealthBar
onready var area: Area2D = $Area2D
onready var bullet_manager: BulletManager = $"../../../BulletManager"

var health := MAX_HP


func _ready():
    # For now all enemies make one pass along their track
    loop = false
    area.connect("area_shape_entered", self, "_on_area_shape_entered")


func _physics_process(delta: float) -> void:
    offset += SPEED * delta

    if unit_offset > 0.99:
        queue_free()


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    var bullet = bullet_manager.get_bullet(area_shape)
    bullet.dead = true
    set_health(health - bullet.damage)


func set_health(new_health: float) -> void:
    health = new_health
    health_bar.set_fraction(health / MAX_HP)
