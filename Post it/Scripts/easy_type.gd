extends Sprite2D

@onready var bar_size :float= $time_bar.size.x

var del:float = 0.0
var alpha :String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var word :String = ""
var size :int
var point :int = 5

func _ready() -> void:
	Global.connect("lost",_lost)
	#disappear typing screen
	$CanvasLayer.visible=false
	$CanvasLayer/word.text = ""
	$CanvasLayer/ColorRect/back.disabled=true
	
	
	#generate random word
	for i in range(randi_range(4,5)):
		word+=alpha[randi_range(0,25)]
	$text.text = word
	size = word.length()
	
	#(avoid overlap) as we are not sure we are overlapping or not
	visible=false

func _process(delta:float)->void:
	if $CanvasLayer.visible:
		#check if typing word matches with our word
		if(str($CanvasLayer/ColorRect2/TextEdit.text).to_upper()== word.to_upper()):
			Global.score+=point
			Global.emit_signal("scored")
			queue_free()
			Global.typing=false
			
	del+=delta
	$time.text = str($Timer.time_left)
	if del>0.05 and not visible:
		#we are assured that its not overlapping
		visible=true
		
	#change time_bar size and colour
	$time_bar.size.x-=delta/$Timer.wait_time*bar_size
	if($time_bar.size.x>bar_size/2):
		$time_bar.color.r8 = 2*(bar_size-$time_bar.size.x)/bar_size *255
	else:
		$time_bar.color.g8 = (2*($time_bar.size.x)/bar_size*255)


func _lost():
	_on_back_pressed()

func _on_timer_timeout() ->void:
	_on_back_pressed() #so that everything disapears and we are back to non typing state
	queue_free()

func _on_area_2d_area_entered(_area) ->void:
	#check for overlapping while spawned.
	if(del<0.05):
		#if overlapped,get removed and spawn other in another place
		Global.emit_signal("spawn")
		queue_free()

func _on_button_pressed() ->void:
	# to get rid of typing state if clicked outside
	if not Global.typing and not Global.is_lost:
		_type()
		Global.typing=true
	
func _type() ->void:
	#typing bar visible stuff
	$CanvasLayer.visible=true
	$CanvasLayer/word.text = word
	$CanvasLayer/ColorRect/back.disabled=false
	$CanvasLayer/ColorRect2/TextEdit.grab_focus()
	$CanvasLayer/ColorRect2/TextEdit.text=""
	
func _on_back_pressed() ->void:
	#typing bar hiding stuff
	$CanvasLayer.visible=false
	$CanvasLayer/word.text = ""
	$CanvasLayer/ColorRect/back.disabled=true
	Global.typing=false
