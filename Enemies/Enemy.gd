extends PathFollow2D


const SPEED = 200


func run_step(delta: float) -> void:
    offset += SPEED * delta
