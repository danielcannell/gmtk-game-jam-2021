extends Node2D


const Enemy = preload("res://Enemies/Enemy.tscn")


onready var path = $Path2D

var enemy = null


func _ready():
    enemy = Enemy.instance()
    path.add_child(enemy)


func _process(delta):
    enemy.offset += 100 * delta
