extends VehicleBody3D

@export_category("Moteur & Vitesse (Style Forza / Asphalt)")
@export var engine_power_normal: float = 1800.0
@export var engine_power_nitro: float = 4200.0
@export var max_steer_angle: float = 0.52
@export var steer_speed: float = 7.0
@export var brake_power: float = 75.0

@export_category("Dynamique de Drift & Adhérence")
@export var normal_grip: float = 1.0
@export var drift_grip: float = 0.4
@export var speed_sensitivity: float = 0.002

@export_category("Nitro & Énergie")
@export var max_nitro: float = 100.0
@export var nitro_drain_speed: float = 35.0
@export var nitro_regen_speed: float = 20.0

var nitro_amount: float = 100.0
var current_speed_kmh: float = 0.0
var touch_steer: float = 0.0
var is_accelerating: bool = false
var is_braking: bool = false
var is_nitro_active: bool = false
var is_drifting: bool = false

@onready var camera_3d: Camera3D = get_node_or_null("Camera3D")

func _ready() -> void:
	nitro_amount = max_nitro
	# Assure un centre de gravité bas pour éviter les retournements irréalistes
	center_of_mass_mode = CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector3(0, -0.4, 0)

func _physics_process(delta: float) -> void:
	current_speed_kmh = linear_velocity.length() * 3.6
	
	# 1. Direction adaptative (plus on va vite, moins les roues braquent sec pour garder le contrôle style console)
	var speed_factor = clamp(1.0 - (current_speed_kmh * speed_sensitivity), 0.4, 1.0)
	var target_steer = touch_steer * max_steer_angle * speed_factor
	steering = move_toward(steering, target_steer, delta * steer_speed)
	
	# 2. Gestion de la puissance (Normale vs Nitro)
	var active_power = engine_power_normal
	if is_nitro_active and nitro_amount > 0:
		active_power = engine_power_nitro
		nitro_amount = max(0.0, nitro_amount - delta * nitro_drain_speed)
		# Effet visuel de vitesse sur la caméra (FOV dynamique)
		if camera_3d:
			camera_3d.fov = lerp(camera_3d.fov, 78.0, delta * 6.0)
	else:
		is_nitro_active = false
		if camera_3d:
			camera_3d.fov = lerp(camera_3d.fov, 60.0, delta * 6.0)
		# Recharge passive de nitro quand on roule à haute vitesse
		if current_speed_kmh > 70 and not is_drifting:
			nitro_amount = min(max_nitro, nitro_amount + delta * (nitro_regen_speed * 0.5))

	# Application de l'accélération et du freinage
	if is_accelerating:
		engine_force = active_power
		brake = 0.0
	elif is_braking:
		engine_force = -active_power * 0.5
		brake = brake_power
	else:
		engine_force = 0.0
		brake = 4.0 # Frein moteur réaliste

	# 3. Mécanique de Drift Arcade (Adhérence dynamique)
	if is_drifting and current_speed_kmh > 50:
		# En mode drift, on gagne de la nitro rapidement
		nitro_amount = min(max_nitro, nitro_amount + delta * nitro_regen_speed)

# --- COMMANDES TACTILES (Reliées aux boutons de l'écran) ---
func set_steer(val: float) -> void:
	touch_steer = val # -1.0 pour Gauche, 1.0 pour Droite, 0.0 pour Neutre

func set_accelerating(active: bool) -> void:
	is_accelerating = active

func set_braking(active: bool) -> void:
	is_braking = active

func set_nitro(active: bool) -> void:
	is_nitro_active = active

func set_drifting(active: bool) -> void:
	is_drifting = active
