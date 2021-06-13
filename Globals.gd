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


enum EnemyType {
    BASIC,
    BOSS,
}


const WAVES = [
    {
        "start": 2 * 60,
        "paths": ["left_to_right"],
        "count": 5,
        "interval": 60,
        "type": EnemyType.BASIC,
    },
    {
        "start": 15 * 60,
        "paths": ["left_to_right_diagonal", "right_to_left_diagonal"],
        "count": 10,
        "interval": 120,
        "type": EnemyType.BASIC,
    },
    {
        "start": 30 * 60,
        "paths": ["loop"],
        "count": 20,
        "interval": 60,
        "type": EnemyType.BASIC,
    },
    {
        "start": 75 * 60,
        "paths": ["boss"],
        "count": 1,
        "interval": 1,
        "type": EnemyType.BOSS,
    }
]
