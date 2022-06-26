extends Area2D

export var speed = 420
var screen_size

signal hit


func _ready():
	hide()
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	Player movement vector (0,0)
	var velocity = Vector2.ZERO
	
#	Handle player movement
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	
	if velocity.length() > 0:
#		Convert to unit vector so diagnol mvmt isn't faster
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

#	Delta makes sure that mvmt consistent when frame rate changes
	position += velocity * delta

#	Keep the player on the screen
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

#	Handling animation based on movement type
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() 
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

# Enable the player to start the game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
