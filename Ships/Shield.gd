extends Area2D


onready var bullet_manager: BulletManager = $"/root/Main/BulletManager"

var active = false;




# Called when the node enters the scene tree for the first time.
func _ready():
    self.connect("area_shape_entered", self, "_on_area_shape_entered")


func _on_area_shape_entered(_area_id: int, _area: Area2D, area_shape: int, _local_shape: int) -> void:
    if active:
        var bullet = bullet_manager.get_bullet(area_shape)
        if !bullet.is_player:
            bullet.dead = true
