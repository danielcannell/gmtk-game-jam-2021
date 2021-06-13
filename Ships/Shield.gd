extends Area2D


onready var bullet_manager: BulletManager = $"/root/Main/BulletManager"
onready var tween: Tween = $Tween
onready var image = $Sprite


func _ready():
    self.connect("area_shape_entered", self, "_on_area_shape_entered")


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    if visible:
        var bullet = bullet_manager.get_bullet(area_shape)
        if !bullet.is_player:
            bullet.dead = true
            damage_effect()


func set_state(on: bool) -> void:
    if visible != on:
        visible = on


func damage_effect() -> void:
    if not tween.is_active():
        var s= Color(1,1,1,1)
        var e= Color(2,2,2,2)
        tween.interpolate_property(image, "modulate",
                s, e, 0.1)
        tween.start()
        yield(tween, "tween_completed")
        tween.interpolate_property(image, "modulate",
                e, s, 0.1)
        tween.start()
