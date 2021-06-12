class_name Bullet
extends Reference

var shape_id : RID
var velocity : Vector2
var position : Vector2
var lifetime : float = 0.0
var animation_lifetime : float = 0.0
var image_offset : int = 0
var layer : String = "front"
var dead := false
var damage := 20.0


func make_snapshot():
    return {
        "velocity": velocity,
        "position": position,
        "lifetime": lifetime,
        "animation_lifetime": animation_lifetime,
        "image_offset": image_offset,
        "layer": layer,
        "dead": dead,
        "damage": damage,
    }

func restore_snapshot(snapshot):
    velocity = snapshot["velocity"]
    position = snapshot["position"]
    lifetime = snapshot["lifetime"]
    animation_lifetime = snapshot["animation_lifetime"]
    image_offset = snapshot["image_offset"]
    layer = snapshot["layer"]
    dead = snapshot["dead"]
    damage = snapshot["damage"]
