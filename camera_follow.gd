extends Camera3D

@export_category("Cible & Suivi")
@export var target_path: NodePath
@export var follow_distance: float = 6.0
@export var follow_height: float = 2.2
@export var smooth_speed: float = 8.0

@export_category("Effets de Vitesse & FOV")
@export var base_fov: float = 60.0
@export var max_fov_boost: float = 78.0
@export var fov_smooth_speed: float = 5.0

var target: Node3D = null

func _ready() -> void:
	if not target_path.is_empty():
		target = get_node(target_path)
	
	# Désactive le parent pour éviter les conflits de position
	set_as_top_level(true)

func _physics_process(delta: float) -> void:
	if not target:
		return

	# 1. Position idéale derrière la voiture
	var target_transform = target.global_transform
	var backward_dir = -target_transform.basis.z
	var upward_dir = target_transform.basis.y
	
	var desired_position = target_transform.origin + (backward_dir * follow_distance) + (upward_dir * follow_height)
	
	# Déplacement fluide de la caméra (effet ressort / damping)
	global_transform.origin = global_transform.origin.lerp(desired_position, delta * smooth_speed)
	
	# 2. Regarder vers la voiture avec un léger décalage vers l'avant pour anticiper la route
	var look_at_target = target_transform.origin + (target_transform.basis.z * 2.0) + (upward_dir * 0.5)
	look_at(look_at_target, Vector3.UP)

	# 3. Effet de vitesse dynamique sur le Champ de Vision (FOV)
	if target.has_method("get") and "current_speed_kmh" in target:
		var speed = target.current_speed_kmh
		var target_fov = lerp(base_fov, max_fov_boost, speed / 300.0)
		fov = lerp(fov, target_fov, delta * fov_smooth_speed)
