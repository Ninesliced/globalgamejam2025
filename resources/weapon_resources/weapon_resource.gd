extends Resource
class_name WeaponResource

enum ShootType {
    SEMI_AUTO,
    AUTO,
}

@export var bullet_scene: PackedScene 
@export var fire_rate: float = 0.5
@export var oxygen_comsuption: float = 5.0
@export var weapon_shoot_type = ShootType.SEMI_AUTO