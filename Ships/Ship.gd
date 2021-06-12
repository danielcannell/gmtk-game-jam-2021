extends Area2D


const HORIZONTAL_SPEED = 300
const FORWARD_SPEED = 200
const REVERSE_SPEED = 200

const MAX_HP = 100.0

onready var image: AnimatedSprite = $Sprite
onready var health_bar: Node2D = $HealthBar

var health := MAX_HP

enum Frames {
    FLAT = 0,
    LEFT = 1,
    RIGHT = 2,
}

func _ready():
    var screen_size = get_viewport_rect().size

    position.x = screen_size.x / 2
    position.y = screen_size.y - 100


func run_step(inputs: InputState, delta: float) -> void:
    var velocity := Vector2(0, 0)

    if inputs.is_pressed(InputType.UP):
        velocity.y -= FORWARD_SPEED
    if inputs.is_pressed(InputType.DOWN):
        velocity.y += REVERSE_SPEED
    if inputs.is_pressed(InputType.LEFT):
        velocity.x -= HORIZONTAL_SPEED
    if inputs.is_pressed(InputType.RIGHT):
        velocity.x += HORIZONTAL_SPEED

    if velocity.x == 0:
        image.set_frame(Frames.FLAT)
    elif velocity.x < 0:
        image.set_frame(Frames.LEFT)
    else:
        image.set_frame(Frames.RIGHT)

    var screen_size = get_viewport_rect().size

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

    health -= 5 * delta
    health_bar.set_fraction(health / MAX_HP)
