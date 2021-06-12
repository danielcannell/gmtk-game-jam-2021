extends Area2D


const HORIZONTAL_SPEED = 300
const FORWARD_SPEED = 200
const REVERSE_SPEED = 200

const MAX_HP = 100.0

onready var left_exhuast = $LeftExhaust;
onready var right_exhuast = $RightExhaust;

onready var image: AnimatedSprite = $Sprite
onready var health_bar: Node2D = $HealthBar


var health := MAX_HP
var fire_cooldown := 0

var left_exhaust_init_pos = Vector2();
var right_exhaust_init_pos = Vector2();
var exhaust_turn_ofs = Vector2(3, 0);


signal fire(position, velocity)


const FIRE_VECTOR = Vector2(0, -1)
const FIRE_SPEED = 20.0
const FIRE_COOLDOWN = 10


enum Frames {
    FLAT = 0,
    LEFT = 1,
    RIGHT = 2,
}


func make_snapshot():
    return {
        "health": health,
        "position": position,
        "fire_cooldown": fire_cooldown,
    }


func restore_snaphot(snapshot):
    if snapshot == null:
        snapshot = {
            "health": 0,
            "position": Vector2(0, 0),
            "fire_cooldown": 0,
        }

    health = snapshot["health"]
    position = snapshot["position"]
    fire_cooldown = snapshot["fire_cooldown"]

    if health <= 0:
        queue_free()


func _ready():
    left_exhaust_init_pos = left_exhuast.position;
    right_exhaust_init_pos = right_exhuast.position;
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
        left_exhuast.position = left_exhaust_init_pos
        right_exhuast.position = right_exhaust_init_pos
    elif velocity.x < 0:
        image.set_frame(Frames.LEFT)
        left_exhuast.position = left_exhaust_init_pos - exhaust_turn_ofs
        right_exhuast.position = right_exhaust_init_pos - exhaust_turn_ofs
    else:
        image.set_frame(Frames.RIGHT)
        left_exhuast.position = left_exhaust_init_pos + exhaust_turn_ofs
        right_exhuast.position = right_exhaust_init_pos + exhaust_turn_ofs

    if velocity.y == 0:
        left_exhuast.set_thrust(1.1)
        right_exhuast.set_thrust(1.1)
    elif velocity.y > 0:
        left_exhuast.set_thrust(0.5)
        right_exhuast.set_thrust(0.5)
    elif velocity.y < 0:
        left_exhuast.set_thrust(1.7)
        right_exhuast.set_thrust(1.7)

    var screen_size = get_viewport_rect().size

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

    if inputs.is_pressed(InputType.FIRE) && fire_cooldown == 0:
        emit_signal("fire", position, FIRE_VECTOR * FIRE_SPEED)
        fire_cooldown = FIRE_COOLDOWN

    if fire_cooldown > 0:
        fire_cooldown -= 1

    health -= 5 * delta
    health_bar.set_fraction(health / MAX_HP)
    if health <= 0:
        queue_free()
