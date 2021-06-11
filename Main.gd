extends Node


const Ship = preload("res://Ships/Ship.tscn")


func _ready():
    # Test code
    var ship := Ship.instance()
    add_child(ship)
