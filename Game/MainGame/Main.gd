extends Node2D

onready var baby_plant = $BabyPlant
onready var plant = $Plant
onready var line_edit = $CanvasLayer/LineEdit
onready var enter_button = $CanvasLayer/EnterButton

onready var start = $MainMenu/Start
onready var main_menu = $MainMenu
onready var plant_response = $CanvasLayer/PlantResponse
onready var canvas_layer = $CanvasLayer
onready var congrats_canvas_layer = $CongratsCanvasLayer

var positive_words
var negative_words



var plant_level=1

var unwanted_chars = [".",",",":","?","!",";" ]

func _ready():
	main_menu.show()
	canvas_layer.hide()
	congrats_canvas_layer.hide()

	
	plant.rect_size.y =138
	plant.rect_position.y =504
	plant.hide()
	baby_plant.show()
	
	plant_response.text=""
	
	var mapData_file= File.new()
	mapData_file.open ( "res://Words/postitivewords.json" , File.READ )
	var mapDatajson= JSON.parse ( mapData_file.get_as_text())
	positive_words=mapDatajson.result
	mapData_file.open ( "res://Words/negativewords.json" , File.READ )
	mapDatajson= JSON.parse ( mapData_file.get_as_text())
	negative_words=mapDatajson.result
	mapData_file.close()


func _on_LineEdit_text_entered(text_entered_by_user):
	var positive_points=0
	var negative_points=0
	
	for c in unwanted_chars:
		text_entered_by_user = text_entered_by_user.replace(c,"")
	var words_entered = text_entered_by_user.rsplit(" ")
	for word in words_entered:
		word = str(word).to_lower()
		if negative_words.has(word):
			negative_points+=1
		elif positive_words.has(word):
			print(positive_words.find(word))
			positive_words.remove(positive_words.find(word))
			positive_points+=1
	if positive_points>negative_points:
		_grow_plant()
	elif negative_points>positive_points:
		_shrink_plant()
	else:
		_neutral_plant()


func _grow_plant():
	plant_level+=1
	baby_plant.hide()
	plant.show()
	plant.rect_size.y +=50
	plant.rect_position.y -=50
	plant_response.text= "The plant is happily growing"
	line_edit.clear()
	if plant.rect_position.y == -846:
		_won_the_game()

func _shrink_plant():
	if plant_level>1:
		plant_level-=1
		plant.rect_size.y -=50
		plant.rect_position.y +=50
	elif plant_level==1:
		plant.rect_size.y =138
		plant.rect_position.y =504
	plant_response.text= "The plant is sadly shrinking"
	line_edit.clear()
	
	

func _neutral_plant():
	plant_response.text= "The plant is silent"
	line_edit.clear()

func _won_the_game():
	canvas_layer.hide()
	congrats_canvas_layer.show()

func _on_EnterButton_pressed():
	_on_LineEdit_text_entered(line_edit.text)


func _on_Start_pressed():
	main_menu.hide()
	canvas_layer.show()
