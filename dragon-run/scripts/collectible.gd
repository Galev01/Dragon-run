extends Area2D

@export var value = 15
@onready var game = $"/root/World" # Change this line
@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		game.add_score(value)
		sprite.play("collected")
		sprite.animation_finished.connect(_on_animation_finished) # Move this line here

func _on_animation_finished():
	queue_free()

func _process(_delta):
	pass
