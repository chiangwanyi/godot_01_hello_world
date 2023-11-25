extends Area2D

@export var speed = 400 # 玩家移动速度 (pixels/sec).
var screen_size # 游戏窗口的尺寸
signal hit

# 当节点第一次进入场景树时调用
func _ready():
	screen_size = get_viewport_rect().size
	print("当前窗口尺寸：", screen_size)
	hide()

# 每一帧都会调用。“delta”是自上一帧以来经过的时间，单位是秒
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# 判断是否输出改变了velocity，Vector2.ZERO的length为0
	if velocity.length() > 0:
		velocity = velocity.normalized()*speed
		# $是get_node()的简写，表示从当前节点的相对路径处寻找节点，未找到返回null
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# 无论当前帧发生在何时，delta的值都是上一帧距离当前帧所经过的时间（单位是秒）
	# 在不同的设备上运行该游戏，游戏的运行帧率与的delta值大小呈反比。
	# 由于 当前帧的移动距离 = 当前速度 * delta（移动时间），因此无论这个游戏的帧率如何，角色的速度都保持一致。
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body):
	print("Player:", body)
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


