extends Node


var score :int= 0
var typing:bool =false
var max_no_of_notes = 5
var level :int= 1
var is_lost :bool = false #to avoid clicking if lost


signal spawn
signal scored
signal lost

