extends PanelContainer

var description: String = ""
var distance: int = 0
var health: float = 0.0

onready var _name = $VBoxContainer/Name
onready var _dist = $VBoxContainer/Dist
onready var _health = $VBoxContainer/Health


func _ready():
    _name.text = description
    _dist.text = str(distance) + "m"
    _health.text = str(int(health))


func set_snapshot(ss, idx: int) -> void:
    var player_ship = ss["ships"][idx]
    distance = ss["frame_num"]
    health = 0 if !is_instance_valid(player_ship) else player_ship.health
    description = "Num " + str(idx)
