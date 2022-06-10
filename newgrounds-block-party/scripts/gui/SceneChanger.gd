extends CanvasLayer

onready var anim := $AnimationPlayer
onready var rect := $Control/ColorRect

onready var t = get_tree()

# not even calling this function yet, just didn't know if someone needed to see the script
func fade_scene(next_scene:PackedScene, twn:Tween = null):
	if twn != null:
		yield(twn, "tween_all_completed")
	anim.play("fade")
	yield(anim, "animation_finished")
	t.change_scene_to(next_scene)
	anim.play_backwards("fade")
