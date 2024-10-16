extends Sprite2D

@onready var bar_size :float= $time_bar.size.x

var alpha :String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var word :String = ""
var size :int
var del:float = 0.0
var point :int = 8

#for understanding code refer to easy_type.gd

func _ready() -> void:
	Global.connect("lost",_lost)
	
	$CanvasLayer.visible=false
	$CanvasLayer/word.text = ""
	$CanvasLayer/ColorRect/back.disabled=true
	visible=false
	for i in range(randi_range(6,7)):
		word+=alpha[randi_range(0,25)]
	$text.text = word
	size = word.length()

func _process(delta:float)->void:
	if $CanvasLayer.visible:
		if(str($CanvasLayer/ColorRect2/TextEdit.text).to_upper()== word.to_upper()):
			Global.score+=point
			Global.emit_signal("scored")
			queue_free()
			Global.typing=false
	del+=delta
	$time.text = str($Timer.time_left)
	if del>0.05 and not visible:
		visible=true
	$time_bar.size.x-=delta/$Timer.wait_time*bar_size
	if($time_bar.size.x>bar_size/2):
		$time_bar.color.r8 = 2*(bar_size-$time_bar.size.x)/bar_size *255
	else:
		$time_bar.color.g8 = (2*($time_bar.size.x)/bar_size*255)

func _on_timer_timeout() -> void:
	_on_back_pressed()
	queue_free()

func _lost():
	_on_back_pressed()

func _on_area_2d_area_entered(_area) -> void:
	if(del<0.05):
		Global.emit_signal("spawn")
		queue_free()

func _on_button_pressed() -> void:
	if not Global.typing and not Global.is_lost:
		_type()
		Global.typing=true
	
func _type() -> void:
	$CanvasLayer.visible=true
	$CanvasLayer/word.text = word
	$CanvasLayer/ColorRect/back.disabled=false
	$CanvasLayer/ColorRect2/TextEdit.grab_focus()
	$CanvasLayer/ColorRect2/TextEdit.text=""
	
func _on_back_pressed() -> void:
	$CanvasLayer.visible=false
	$CanvasLayer/word.text = ""
	$CanvasLayer/ColorRect/back.disabled=true
	Global.typing = false
