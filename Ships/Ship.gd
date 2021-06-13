extends Node2D
class_name Ship


const HORIZONTAL_SPEED = 300
const FORWARD_SPEED = 200
const REVERSE_SPEED = 200

const MAX_HP = 100.0

onready var left_exhuast = $LeftExhaust;
onready var right_exhuast = $RightExhaust;

onready var image: AnimatedSprite = $Sprite
onready var health_bar: Node2D = $HealthBar
onready var bullet_manager: BulletManager = $"../../BulletManager"
onready var tween = $Tween
onready var label = $"Lbls/Label"


enum ShipType {
    BULLET,
    SHIELD
}

enum Frames {
    FLAT = 0,
    LEFT = 1,
    RIGHT = 2,
}

const CONFIG = {
    ShipType.BULLET: {
       "frames": {
           Frames.FLAT: 0,
           Frames.LEFT: 1,
           Frames.RIGHT: 2
       },
       "exhaust_turn_ofs": Vector2(3, 0),
       "exhaust_turn_y_ofs": -5,
    },
    ShipType.SHIELD: {
        "frames": {
            Frames.FLAT: 5,
            Frames.LEFT: 3,
            Frames.RIGHT: 4
        },
        "exhaust_turn_ofs": Vector2(3, 0),
        "exhaust_turn_y_ofs": -5,
    }
}


var health := MAX_HP
var fire_cooldown := 0
var dead := false

var left_exhaust_init_pos := Vector2()
var right_exhaust_init_pos := Vector2()
var ship_type: int = ShipType.SHIELD


signal fire(position, velocity)
signal death(position)


const FIRE_VECTOR = Vector2(0, -1)
const FIRE_SPEED = 600.0
const FIRE_COOLDOWN = 5


func make_snapshot():
    return {
        "health": health,
        "position": position,
        "fire_cooldown": fire_cooldown,
        "ship_type": ship_type,
        "dead": dead,
    }


func restore_snapshot(snapshot):
    if snapshot == null:
        snapshot = {
            "health": 0,
            "position": Vector2(0, 0),
            "fire_cooldown": 0,
            "ship_type": ShipType.BULLET,
            "dead": true,
        }

    set_health(snapshot["health"])
    position = snapshot["position"]
    fire_cooldown = snapshot["fire_cooldown"]
    ship_type = snapshot["ship_type"]
    dead = snapshot["dead"]


func damage_effect() -> void:
    var s= Color(1,1,1,1)
    var e= Color(6,6,6,6)
    tween.interpolate_property(image, "modulate",
            s, e, 0.1)
    tween.start()
    yield(tween, "tween_completed")
    tween.interpolate_property(image, "modulate",
            e, s, 0.1)
    tween.start()


func _ready():
    left_exhaust_init_pos = left_exhuast.position
    right_exhaust_init_pos = right_exhuast.position
    right_exhuast.set_mod(10)
    var screen_size = get_viewport_rect().size

    position.x = screen_size.x / 2
    position.y = screen_size.y - 100

    $Area2D.connect("area_shape_entered", self, "_on_area_shape_entered")


func _update_ship(velocity: Vector2) -> void:
    """update the visual of the ship"""
    var conf = CONFIG[ship_type]
    var exhaust_turn_ofs = conf['exhaust_turn_ofs']
    if velocity.x == 0:
        image.set_frame(conf['frames'][Frames.FLAT])
        left_exhuast.position = left_exhaust_init_pos
        right_exhuast.position = right_exhaust_init_pos
        left_exhuast.set_trail_bend(0)
        right_exhuast.set_trail_bend(0)
    elif velocity.x < 0:
        image.set_frame(conf['frames'][Frames.LEFT])
        left_exhuast.position = left_exhaust_init_pos - exhaust_turn_ofs + Vector2(0, conf['exhaust_turn_y_ofs'])
        right_exhuast.position = right_exhaust_init_pos - exhaust_turn_ofs
        left_exhuast.set_trail_bend(-200)
        right_exhuast.set_trail_bend(-200)
    else:
        image.set_frame(conf['frames'][Frames.RIGHT])
        left_exhuast.position = left_exhaust_init_pos + exhaust_turn_ofs
        right_exhuast.position = right_exhaust_init_pos + exhaust_turn_ofs + Vector2(0, conf['exhaust_turn_y_ofs'])
        left_exhuast.set_trail_bend(200)
        right_exhuast.set_trail_bend(200)

    if velocity.y == 0:
        left_exhuast.set_thrust(1.1)
        right_exhuast.set_thrust(1.1)
    elif velocity.y > 0:
        left_exhuast.set_thrust(0.5)
        right_exhuast.set_thrust(0.5)
    elif velocity.y < 0:
        left_exhuast.set_thrust(1.8)
        right_exhuast.set_thrust(1.8)


func handle_fire(fire_pressed: bool):
    if fire_pressed && fire_cooldown == 0:
        emit_signal("fire", position, FIRE_VECTOR * FIRE_SPEED, true)
        fire_cooldown = FIRE_COOLDOWN


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

    _update_ship(velocity)

    var screen_size = get_viewport_rect().size

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

    handle_fire(inputs.is_pressed(InputType.FIRE))

    if fire_cooldown > 0:
        fire_cooldown -= 1

    if health <= 0:
        emit_signal("death", position)
        dead = true


func set_type(new_type: int) -> void:
    ship_type = new_type


func set_health(new_health: float) -> void:
    health = new_health
    health_bar.set_fraction(health / MAX_HP)


func set_label(text: String) -> void:
    label.text = text


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    var bullet = bullet_manager.get_bullet(area_shape)
    if !bullet.is_player:
        damage_effect()
        bullet.dead = true
        set_health(health - bullet.damage)
