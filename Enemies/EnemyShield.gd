extends Area2D


const MAX_ENERGY := 300
const RECHARGE_RATE := 1
const DAMAGE_RATE := 100


onready var bullet_manager: BulletManager = $"/root/Main/BulletManager"
onready var tween: Tween = $Tween
onready var image = $Sprite

var energy := 0


func _ready():
    self.connect("area_shape_entered", self, "_on_area_shape_entered")


func run_tick() -> void:
    if visible:
        if energy == 0:
            visible = false
        else:
            energy += RECHARGE_RATE
            if energy > MAX_ENERGY:
                energy = MAX_ENERGY


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    if visible:
        var bullet = bullet_manager.get_bullet(area_shape)
        if bullet.is_player:
            bullet.dead = true

            if bullet.type == Bullet.BulletType.ENERGY:
                energy -= DAMAGE_RATE
                shield_damage_effect()
                if energy < 0:
                    energy = 0
            else:
                damage_effect()

func set_state(on: bool) -> void:
    set_energy(MAX_ENERGY if on else 0)


func set_energy(e: int) -> void:
    energy = e
    visible = (e > 0)


func damage_effect() -> void:
    if not tween.is_active():
        var s= Color(1,1,1,1)
        var e= Color(1.1,1.1,2.0,1.0)
        tween.interpolate_property(image, "modulate",
                s, e, 0.1)
        tween.start()
        yield(tween, "tween_completed")
        tween.interpolate_property(image, "modulate",
                e, s, 0.1)
        tween.start()


func shield_damage_effect() -> void:
    if not tween.is_active():
        var s= Color(1,1,1,1)
        var e= Color(2,1.1,1.1,1.0)
        tween.interpolate_property(image, "modulate",
                s, e, 0.1)
        tween.start()
        yield(tween, "tween_completed")
        tween.interpolate_property(image, "modulate",
                e, s, 0.3)
        tween.start()
