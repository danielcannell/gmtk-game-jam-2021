extends PathFollow2D


const SPEED = 200
const MAX_HP = 100.0

onready var health_bar: Node2D = $HealthBar

var health := MAX_HP


func _ready():
    # For now all enemies make one pass along their track
    loop = false


func _physics_process(delta: float) -> void:
    offset += SPEED * delta

    if unit_offset > 0.99:
        queue_free()

    health -= 5 * delta
    health_bar.set_fraction(health / MAX_HP)
