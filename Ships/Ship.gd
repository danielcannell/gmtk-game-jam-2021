extends Area2D


func _ready():
    pass


func run_step(input, delta: float) -> void:
    var velocity := Vector2(0, 10)

    var screen_size = get_viewport_rect().size


    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
