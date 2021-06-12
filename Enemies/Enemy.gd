extends PathFollow2D


const SPEED = 200


func _ready():
    # For now all enemies make one pass along their track
    loop = false


func _physics_process(delta: float) -> void:
    offset += SPEED * delta

    if unit_offset > 0.99:
        queue_free()
