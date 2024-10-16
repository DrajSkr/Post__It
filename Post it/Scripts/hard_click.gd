extends Sprite2D

@onready var bar_size :float= $time_bar.size.x

var del :float = 0.0
var point :int = 2

#for understanding code refer to easy_click

func _ready() -> void:
	visible=false
	

func _on_timer_timeout():
	queue_free()

func _process(delta :float) -> void:
	$time.text = str($Timer.time_left)
	del += delta
	if del>0.03 and not visible:
		visible=true
	$time_bar.size.x-=delta/$Timer.wait_time*bar_size
	if($time_bar.size.x>bar_size/2):
		$time_bar.color.r8 = 2*(bar_size-$time_bar.size.x)/bar_size *255
	else:
		$time_bar.color.g8 = (2*($time_bar.size.x)/bar_size*255)

func _on_button_pressed() -> void:
	queue_free()
	Global.score+=point
	Global.emit_signal("scored")


func _on_area_2d_area_entered(_area) -> void:
	if(del<0.05):
		Global.emit_signal("spawn")
		queue_free()

