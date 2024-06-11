extends Area2D


var MAX_TIME = 15
var time = 0.0
var created = false
var run = false

var colors = ["green", "red", "blue", "yellow", "purple"]

var first
var second
var third

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($Sprite1.animation)
	if run:
		if $Sprite3.animation.ends_with("fly"):
			position += transform.x * delta * 60 * 5
			time += 10 * delta
			if time > MAX_TIME:
				$Sprite5.play(first + "_end")
				$Sprite4.play(second + "_end")
				$Sprite1.play(first + "_end")
				$Sprite2.play(second + "_end")
				$Sprite3.play(third + "_end")
				queue_free()
		else:
			if !created:
				created = true
				position += transform.x * 60 * delta * 600
				
				var rnd = randi() % 5
				first = colors[rnd]
				rnd = randi() % 5
				second = colors[rnd]
				rnd = randi() % 5
				third = colors[rnd]
				$Sprite1.visible = true
				$Sprite1.play(first + "_start")
				await get_tree().create_timer(0.2).timeout
				$Sprite2.visible = true
				$Sprite2.play(second + "_start")
				await get_tree().create_timer(0.2).timeout
				$Sprite3.visible = true
				$Sprite3.play(third + "_start")
				await get_tree().create_timer(0.2).timeout



func _on_sprite_animation_finished():
	if $Sprite1.animation.ends_with("end") or $Sprite3.animation.ends_with("end") or $Sprite2.animation.ends_with("end"):
		queue_free()
	if $Sprite3.animation.ends_with("start") and run:
		if first == second and second == third:
			await get_tree().create_timer(0.1).timeout
			$SmallShape.disabled = true
			$BigShape.disabled = false
			$Sprite4.visible = true
			$Sprite5.visible = true
			$Sprite5.play(third + "_start")
			$Sprite4.play(third + "_start")
		else:
			await get_tree().create_timer(0.1).timeout
			if run:
				$Sprite1.play(first + "_fly")
				$Sprite2.play(second + "_fly")
				$Sprite3.play(third + "_fly")
	if $Sprite5.animation.ends_with("start") and run:
		await get_tree().create_timer(0.2).timeout
		if run:
			$Sprite1.play(first + "_fly")
			$Sprite2.play(second + "_fly")
			$Sprite3.play(third + "_fly")
			$Sprite5.play(second + "_fly")
			$Sprite4.play(third + "_fly")
	


func _on_area_entered(area):
	if area.is_in_group("Player") and $Sprite3.animation.ends_with("fly"):
		run = false
		$Sprite3.play(third + "_end")
		$Sprite5.play(first + "_end")
		$Sprite4.play(second + "_end")
		$Sprite1.play(first + "_end")
		$Sprite2.play(second + "_end")
