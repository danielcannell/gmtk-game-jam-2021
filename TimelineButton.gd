extends Button

export (Array, Image) var frames

var title: String = ""
var type: int = 0
var distance: int = 0
var health: float = 0.0
var played: bool = false

onready var _name = $VBoxContainer/Name
onready var _type = $VBoxContainer/Type
onready var _dist = $VBoxContainer/Dist
onready var _health = $VBoxContainer/Health
onready var _help = $VBoxContainer/Help
onready var _image = $VBoxContainer/CenterContainer/TextureRect


func post_init():
    _name.text = title
    _type.text = Ship.ShipType.keys()[type]
    _image.texture = frames[type]
    if played:
        _dist.text = "Distance: " + str(distance) + "m"
        _health.text = "Health: " + str(int(health))
        if health > 0:
            _help.text = "Saved!\nClick to resume"
        else:
            _help.text = "Dead"
    else:
        _dist.text = ""
        _health.text = ""
        _help.text = "Click to start"


func set_snapshot(ss, idx: int) -> void:
    title = "Ship " + str(idx + 1)
    type = idx % 3
    if ss == null:
        # Not played yet
        played = false
        disabled = false
    else:
        var player_ship = ss["ships"][idx]
        var dead: bool = player_ship == null || player_ship["dead"]
        distance = ss["frame_num"]
        health = 0 if dead else player_ship.health
        disabled = dead
        played = true
