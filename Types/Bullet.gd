class_name Bullet
extends Reference

enum BulletType {
    NORMAL,
    ENERGY,
}


var shape_id : RID
var velocity : Vector2
var position : Vector2
var lifetime : float = 0.0
var animation_lifetime : float = 0.0
var image_offset : int = 0
var dead := false
var damage := 20.0
var is_player := true
var type: int = BulletType.NORMAL
