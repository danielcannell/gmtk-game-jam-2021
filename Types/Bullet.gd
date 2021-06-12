class_name Bullet
extends Reference

var shape_id : RID
var velocity : Vector2
var position : Vector2
var lifetime : float = 0.0
var animation_lifetime : float = 0.0
var image_offset : int = 0
var dead := false
var damage := 20.0
var is_player := true


func make_snapshot():
    return {
        "velocity": velocity,
        "position": position,
        "lifetime": lifetime,
        "animation_lifetime": animation_lifetime,
        "image_offset": image_offset,
        "dead": dead,
        "damage": damage,
        "is_player": is_player,
    }

func restore_snapshot(snapshot):
    velocity = snapshot["velocity"]
    position = snapshot["position"]
    lifetime = snapshot["lifetime"]
    animation_lifetime = snapshot["animation_lifetime"]
    image_offset = snapshot["image_offset"]
    dead = snapshot["dead"]
    damage = snapshot["damage"]
    is_player = snapshot["is_player"]
