extends Node2D


func _ready():
    $BulletManager.set_bounding_box(get_viewport_rect().grow(16))
