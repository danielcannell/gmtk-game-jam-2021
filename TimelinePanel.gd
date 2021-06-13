extends Button

var description: String = ""
var distance: int = 0
var health: float = 0.0
var played: bool = false

onready var _name = $VBoxContainer/Name
onready var _dist = $VBoxContainer/Dist
onready var _health = $VBoxContainer/Health
onready var _help = $VBoxContainer/Help


func _ready():
    _name.text = description
    if played:
        _dist.text = "Distance: " + str(distance) + "m"
        _health.text = "Health: " + str(int(health))
        if health > 0:
            _help.text = "Saved!\nClick to resume"
        else:
            _help.text = "Dead"
    else:
        _help.text = "Click to start"


func set_snapshot(ss, idx: int) -> void:
    description = "Ship " + str(idx)
    if ss == null:
        # Not played yet
        played = false
    else:
        var player_ship = ss["ships"][idx]
        var dead: bool = player_ship == null || player_ship["dead"]
        distance = ss["frame_num"]
        health = 0 if dead else player_ship.health
        disabled = dead
        played = true
