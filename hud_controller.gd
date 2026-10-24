extends Control

@export var car_path: NodePath
var car_node: Node3D = null

# Références des éléments de l'interface (Labels et Barres)
@onready var speed_label: Label = $SpeedLabel
@onready var nitro_bar: TextureProgressBar = $NitroBar
@onready var gear_label: Label = $GearLabel
@onready var timer_label: Label = $TimerLabel

var elapsed_time: float = 0.0

func _ready() -> void:
	if not car_path.is_empty():
		car_node = get_node(car_path)

func _process(delta: float) -> void:
	elapsed_time += delta
	
	# Mise à jour du Chronomètre au format propre (Minutes:Secondes)
	var minutes = int(elapsed_time / 60)
	var seconds = fmod(elapsed_time, 60.0)
	timer_label.text = "%02d:%05.2f" % [minutes, seconds]

	if car_node:
		# 1. Récupération de la vitesse de la voiture en km/h
		if "current_speed_kmh" in car_node:
			var speed = int(car_node.current_speed_kmh)
			speed_label.text = str(speed) + " KM/H"
			
			# Animation dynamique du texte selon la vitesse (légère variation d'échelle)
			var speed_ratio = float(speed) / 350.0
			speed_label.scale = Vector2.ONE * lerp(1.0, 1.15, speed_ratio)

		# 2. Mise à jour de la jauge de Nitro avec effet visuel
		if "nitro_amount" in car_node and "max_nitro" in car_node:
			var nitro_val = car_node.nitro_amount
			var max_val = car_node.max_nitro
			nitro_bar.value = (nitro_val / max_val) * 100.0
			
			# Effet de pulsation de la jauge si la nitro est active
			if "is_nitro_active" in car_node and car_node.is_nitro_active:
				nitro_bar.modulate = Color(1.2, 1.5, 2.0, 1.0) # Teinte bleue lumineuse boostée
			else:
				nitro_bar.modulate = Color(1.0, 1.0, 1.0, 1.0)
