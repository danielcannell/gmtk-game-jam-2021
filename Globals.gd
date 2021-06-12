extends Node

var timelines: Array = []
var live_timeline := 0

const player_bullet_color := Color(0, 1, 1)
const enemy_bullet_color := Color(1, 0, 0)

enum Layers {
    ENEMY,
    PLAYER,
    BULLETS,
}
