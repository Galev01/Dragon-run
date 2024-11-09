extends CharacterBody2D

signal player_died
signal enemy_killed

# Variables for gravity and jump power
@export var gravity = 1600
@export var jump_power = 600

# Get references to necessary nodes
@onready var sprite = $AnimatedSprite2D
@onready var jump_sound = $jumpsound
@onready var camera = $"/root/World/Camera2D"
@onready var death_sound = $deathsound
@onready var collision_shape = $CollisionShape2D
@onready var game = $"/root/World"
@onready var shoot_sound = $shootsound
@onready var projectile_position = $"Projectileposition"


# Define initial state variables
var projectile = preload("res://Scenes/projectile.tscn")
var active = true
var jumps_remaining = 3
var was_jumping = false
var jump_pitch = 1
var ammo = 3

# Called when the node enters the scene tree for the first time
func _ready():
	print("hello world")
	sprite.animation_finished.connect(_on_animation_finished)

# Called every physics frame
func _physics_process(delta):
	# Apply gravity to the character
	velocity.y += gravity * delta

	if active:  # If the character phase is active
		# Update the camera position
		camera.position = position
		# Reset jumps after landing
		if was_jumping and is_on_floor():
			was_jumping = false
			jumps_remaining = 2
			sprite.play("Run")
			jump_pitch = 1
		# Handle jumping
		if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
			jumps_remaining -= 1
			was_jumping = true
			velocity.y = -jump_power

			# Change animation based on remaining jumps
			if jumps_remaining == 1:
				sprite.play("jump")
			else:
				sprite.play("double jump")

			# Play jump sound with increasing pitch
			jump_sound.set_pitch_scale(jump_pitch)
			jump_sound.play()
			jump_pitch += 0.1

	# Move the character
	move_and_slide()

func _input(event):
	if event.is_action_pressed("fire") and ammo > 0:
		var projectile_instance = projectile.instantiate()
		projectile_instance.position = projectile_position.global_position
		game.add_child(projectile_instance)
		shoot_sound.play()
		sprite.play("Shoot")
		ammo -= 1
		emit_signal("enemy_killed")
		


func die():
	death_sound.play()
	sprite.play("death")
	active = false
	collision_shape.set_deferred("disabled", true)
	emit_signal("player_died")

func _on_animation_finished():
	if sprite.animation == "Shoot":
		sprite.play("Run")

func add_ammo(amount):
	ammo += amount
