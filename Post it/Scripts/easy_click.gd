extends Sprite2D

@onready var bar_size :float= $time_bar.size.x
var point :int = 1

var del :float = 0.0 #time since it is on screen

func _ready():
	#avoid overlap
	visible=false


func _on_timer_timeout():
	queue_free()

func _process(delta):
	$time.text = str($Timer.time_left)
	del += delta
	if del>0.03 and not visible:
		#assured that we are not overlapping
		visible=true
		
	#change time_bar size and colour
	$time_bar.size.x-=delta/$Timer.wait_time*bar_size #decrease time_bar
	if($time_bar.size.x>bar_size/2): #for colour changing of time bar
		$time_bar.color.r8 = 2*(bar_size-$time_bar.size.x)/bar_size *255
	else:
		$time_bar.color.g8 = (2*($time_bar.size.x)/bar_size *255)


func _on_button_pressed():
	#add score
	queue_free()
	Global.score+=point
	Global.emit_signal("scored")


func _on_area_2d_area_entered(_area):
	#to avoid overlapping of notes
	if(del<0.05):
		#we are overlapping so remove self and spawn another
		Global.emit_signal("spawn")
		queue_free()
