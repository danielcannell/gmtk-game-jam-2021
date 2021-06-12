class_name BulletManager
extends Node2D

export (Array, Image) var frames
export (float) var image_change_offset = 0.2
export (float) var max_lifetime = 10.0

# the areas in which bullets operate
onready var shared_area = $SharedArea;

onready var max_images = frames.size()

var bullets : Array = []
var bounding_box : Rect2


func make_snapshot():
    var snapshot = []

    for b in bullets:
        snapshot.append(b.make_snapshot())

    return snapshot


func restore_snapshot(snapshot):
    for b in snapshot:
        spawn_bullet(Vector2(), Vector2(), false)
        bullets[-1].restore_snaphot(b)


# ================================ Lifecycle ================================ #

func _exit_tree() -> void:
    for bullet in bullets:
        Physics2DServer.free_rid((bullet as Bullet).shape_id)
    bullets.clear()

func _physics_process(delta: float) -> void:

    var used_transform = Transform2D()
    var bullets_queued_for_destruction = []

    for i in bullets.size():

        var bullet = bullets[i] as Bullet

        if (
            !bounding_box.has_point(bullet.position) ||
            bullet.lifetime >= max_lifetime ||
            bullet.dead
        ):
            bullets_queued_for_destruction.append(bullet)
            continue

        # Move the bullet and the collision
        bullet.position += bullet.velocity * delta
        used_transform.origin = bullet.position

        # move the 2d collision shape the the position of the bullet
        Physics2DServer.area_set_shape_transform(
            shared_area.get_rid(), i, used_transform
        )

        bullet.animation_lifetime += delta
        bullet.lifetime += delta

    for bullet in bullets_queued_for_destruction:
        Physics2DServer.free_rid(bullet.shape_id)
        bullets.erase(bullet)

    update()

func _draw() -> void:
    var offset = frames[0].get_size() / 2.0
    for i in range(0, bullets.size()):
        var bullet = bullets[i]
        if bullet.animation_lifetime >= image_change_offset:
            bullet.image_offset += 1
            bullet.animation_lifetime = 0.0
            if bullet.image_offset >= max_images:
                bullet.image_offset = 0

        var color = Globals.enemy_bullet_color
        if bullet.is_player:
            color = Globals.player_bullet_color
        draw_texture(
            frames[bullet.image_offset],
            bullet.position - offset,
            color
        )

# ================================= Public ================================== #

# Bullets outside these bounds will be deleted
func set_bounding_box(box: Rect2) -> void:
    bounding_box = box

# Register a new bullet in the array with the optimization logic
func spawn_bullet(position: Vector2, velocity: Vector2, is_player: bool) -> void:
    var bullet : Bullet = Bullet.new()
    bullet.velocity = velocity
    bullet.position  = position
    bullet.is_player = is_player

    _configure_collision_for_bullet(bullet)

    bullets.append(bullet)

# Adds the collision data to the bullet
func _configure_collision_for_bullet(bullet: Bullet) -> void:

    # Define the shape's position
    var used_transform := Transform2D(0, position)
    used_transform.origin = bullet.position

    # Create the shape
    var _circle_shape = Physics2DServer.circle_shape_create()
    Physics2DServer.shape_set_data(_circle_shape, 8)

    # Add the shape to the shared area
    Physics2DServer.area_add_shape(
        shared_area.get_rid(), _circle_shape, used_transform
    )

    # Register the generated id to the bullet
    bullet.shape_id = _circle_shape


func get_bullet(id: int) -> Bullet:
    return bullets[id]
