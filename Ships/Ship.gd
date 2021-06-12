extends Area2D


const HORIZONTAL_SPEED = 300
const FORWARD_SPEED = 200
const REVERSE_SPEED = 200

const MAX_HP = 100.0

onready var left_exhuast = $LeftExhaust;
onready var right_exhuast = $RightExhaust;

onready var image: AnimatedSprite = $Sprite
onready var health_bar: Node2D = $HealthBar
onready var bullet_manager: BulletManager = $"../../BulletManager"


var health := MAX_HP
var fire_cooldown := 0

var left_exhaust_init_pos = Vector2();
var right_exhaust_init_pos = Vector2();
var exhaust_turn_ofs = Vector2(3, 0);


signal fire(position, velocity)


const FIRE_VECTOR = Vector2(0, -1)
const FIRE_SPEED = 600.0
const FIRE_COOLDOWN = 5


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
    right_exhuast.set_mod(10)
    var screen_size = get_viewport_rect().size

    position.x = screen_size.x / 2
    position.y = screen_size.y - 100

    self.connect("area_shape_entered", self, "_on_area_shape_entered")


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
        left_exhuast.set_trail_bend(0)
        right_exhuast.set_trail_bend(0)
    elif velocity.x < 0:
        image.set_frame(Frames.LEFT)
        left_exhuast.position = left_exhaust_init_pos - exhaust_turn_ofs
        right_exhuast.position = right_exhaust_init_pos - exhaust_turn_ofs
        left_exhuast.set_trail_bend(-200)
        right_exhuast.set_trail_bend(-200)
    else:
        image.set_frame(Frames.RIGHT)
        left_exhuast.position = left_exhaust_init_pos + exhaust_turn_ofs
        right_exhuast.position = right_exhaust_init_pos + exhaust_turn_ofs
        left_exhuast.set_trail_bend(200)
        right_exhuast.set_trail_bend(200)

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
        emit_signal("fire", position, FIRE_VECTOR * FIRE_SPEED, true)
        fire_cooldown = FIRE_COOLDOWN

    if fire_cooldown > 0:
        fire_cooldown -= 1

    if health <= 0:
        queue_free()


func set_health(new_health: float) -> void:
    health = new_health
    health_bar.set_fraction(health / MAX_HP)


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    var bullet = bullet_manager.get_bullet(area_shape)
    if !bullet.is_player:
        bullet.dead = true
        set_health(health - bullet.damage)
