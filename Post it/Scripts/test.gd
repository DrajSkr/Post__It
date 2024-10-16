extends Node2D

@onready var spawn_timer = $spawn_timer

@onready var easy_click = preload("res://Scenes/Tasks/easy_click.tscn")
@onready var hard_click = preload("res://Scenes/Tasks/hard_click.tscn")
@onready var easy_type = preload("res://Scenes/Tasks/easy_type.tscn")
@onready var medium_type = preload("res://Scenes/Tasks/medium_type.tscn")
@onready var hard_type = preload("res://Scenes/Tasks/hard_type.tscn")

var tasks :Array

var completed :bool =false

@onready var bar_size :float= $time_bar.size.x

var req_point = 20 + (Global.level-1) * 15 #15 more points for each increasing level


func _ready() -> void:
	$level_label.text = "Level: "+ str(Global.level)
	$score_label.text = "Score: 0/"+str(req_point)
	
	
	$score_bar.max_value = req_point
	Global.score = 0
	Global.is_lost = false
	
	
	$fade.visible=true
	$fade.color.a8 = 255
	$AnimationPlayer.play_backwards("fade")
	Global.connect("scored",_scored)
	
	$Timer.start(20 + Global.level*10)
	
	Global.connect("spawn",_spawn)
	spawn_timer.start(randf_range(0.2,1)) #how frequently each notes spawn(adjust time according to your need)
	tasks = [easy_click,hard_click,easy_type,medium_type,hard_type]
	
	

	
func _process(delta:float) -> void:
	
	$time_bar.size.x-=delta/$Timer.wait_time*bar_size #decrease time_bar
	if($time_bar.size.x>bar_size/2): #for colour changing of time bar
		$time_bar.color.r8 = 2*(bar_size-$time_bar.size.x)/bar_size *255
	else:
		$time_bar.color.g8 = (2*($time_bar.size.x)/bar_size *255)

func _on_spawn_timer_timeout():
	_spawn()
	spawn_timer.start(randf_range(1,3))

func _spawn():
	call_deferred("spawn")



func spawn():
	#spawning a random notes
	if(get_node("notes").get_child_count()<Global.max_no_of_notes):# to avoid huge number of notes in screen
		var obj=tasks[randi_range(0,tasks.size()-1)].instantiate() #random note from tasks array
		
		#adding that obj in notes node
		get_node("notes").add_child(obj)
		obj.global_position= Vector2(randi_range(20,1720),randi_range(40,900))


func _scored():
	$score_bar.value=Global.score
	$score_label.text = "Score: "+str(min(Global.score,req_point))+"/"+str(req_point)
	if Global.score>=req_point and not completed:
		completed=true
		$fade.visible=true
		$fade.color.a = 0
		$AnimationPlayer.play("fade")
		await $AnimationPlayer.animation_finished
		Global.level+=1
		get_tree().reload_current_scene()



func _on_animation_player_animation_finished(anim_name):
	$fade.visible=false


func _on_timer_timeout():
	if not completed: #game lost
		Global.emit_signal("lost")
		Global.is_lost = true
		$fade.visible=true
		$fade.color.a=0
		$AnimationPlayer.play("fade")
		$"fade/you lose".visible=true
		await $AnimationPlayer.animation_finished
		Global.level=1
		get_tree().reload_current_scene()
