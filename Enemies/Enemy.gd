extends PathFollow2D


const SPEED = 200
const MAX_HP = 100.0

onready var health_bar: Node2D = $HealthBar
onready var area: Area2D = $Area2D

var health := MAX_HP


func _ready():
    # For now all enemies make one pass along their track
    loop = false
    area.connect("area_shape_entered", self, "_on_area_shape_entered")


func _physics_process(delta: float) -> void:
    offset += SPEED * delta

    if unit_offset > 0.99:
        queue_free()

    health -= 5 * delta
    health_bar.set_fraction(health / MAX_HP)


func _on_area_shape_entered(area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    print(area_id, " - ", area_shape)
