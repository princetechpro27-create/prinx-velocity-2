extends Control

@export var car_path: NodePath
var car_node: Node3D = null

func _ready() -> void:
	if not car_path.is_empty():
		car_node = get_node(car_path)

# --- GESTION DES BOUTONS TACTILES ---

# Bouton Gauche
func _on_btn_left_pressed() -> void:
	if car_node and car_node.has_method("set_steer"):
		car_node.set_steer(-1.0)

func _on_btn_left_released() -> void:
	if car_node and car_node.has_method("set_steer"):
		car_node.set_steer(0.0)

# Bouton Droite
func _on_btn_right_pressed() -> void:
	if car_node and car_node.has_method("set_steer"):
		car_node.set_steer(1.0)

func _on_btn_right_released() -> void:
	if car_node and car_node.has_method("set_steer"):
		car_node.set_steer(0.0)

# Bouton Accélérateur
func _on_btn_gas_down() -> void:
	if car_node and car_node.has_method("set_accelerating"):
		car_node.set_accelerating(true)

func _on_btn_gas_up() -> void:
	if car_node and car_node.has_method("set_accelerating"):
		car_node.set_accelerating(false)

# Bouton Frein
func _on_btn_brake_down() -> void:
	if car_node and car_node.has_method("set_braking"):
		car_node.set_braking(true)

func _on_btn_brake_up() -> void:
	if car_node and car_node.has_method("set_braking"):
		car_node.set_braking(false)

# Bouton Nitro
func _on_btn_nitro_down() -> void:
	if car_node and car_node.has_method("set_nitro"):
		car_node.set_nitro(true)

func _on_btn_nitro_up() -> void:
	if car_node and car_node.has_method("set_nitro"):
		car_node.set_nitro(false)

# Bouton Drift
func _on_btn_drift_down() -> void:
	if car_node and car_node.has_method("set_drifting"):
		car_node.set_drifting(true)

func _on_btn_drift_up() -> void:
	if car_node and car_node.has_method("set_drifting"):
		car_node.set_drifting(false)
