extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#const Sprite_farmer = preload('res://Sprite_farmer.gd')

class_name Sprite_land

var _land_name: String
var _farmer_productivity: Dictionary = {}

#class_name Sprite_farmer
var _owner_farmer: Sprite_farmer
var _farmer_in_the_land: Sprite_farmer
var _current_rent: float

var _node_main_ref: Node_Main

# Called when the node enters the scene tree for the first time.
func _ready():
	#Solo para pruebas
	#var defaultTexture = preload("res://grass.png") # resource is loaded at compile time
	#set_texture(defaultTexture)
	#set_position(Vector2(250,80))
	#Hasta aquí solo para pruebas
	
	#currentRent = 0.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset() -> void:
	_farmer_in_the_land = null
	_current_rent = 0
	
	
func get_house() -> Node:
	var sprite_house: Sprite = $Sprite_house as Sprite #casting al estilo gdscript
	return sprite_house
	

func set_farmer_productivity(farmer: Sprite_farmer , productivity: float) -> void:
	_farmer_productivity[farmer] = productivity
	draw_productivities()
	
	
func set_land_name(land_name_arg: String) -> void:
	self._land_name = land_name_arg
	
	
func get_land_name() -> String:
	return _land_name
	
	
func set_owner_farmer(farmer: Sprite_farmer) -> void:
	_owner_farmer = farmer
	draw_owner()
	
func get_owner_farmer() -> Sprite_farmer:
	return _owner_farmer
	
	
func draw_owner() -> void:
	var owner_text = "Owner:\n"
	if _owner_farmer != null:
		owner_text += _owner_farmer.get_farmer_name()
		$Label_owner.text = owner_text
	
	
func draw_productivities() -> void:
	var textOfProductivities = []
	for farmer in _farmer_productivity:
		if null != farmer:
			var textFarmer = farmer.get_farmer_name()
			var productivity = _farmer_productivity[farmer]
			var prodText = str(productivity)
			var textLine = textFarmer + ": " + prodText
			textOfProductivities.append(textLine)
	var completeText = "Productivities:\n"
	for textLine in textOfProductivities:
		completeText += textLine + "\n"
	$Label_productivities.text = completeText
	
	
func set_farmer_in_the_land(farmer_arg: Sprite_farmer) -> void:
	print ("set_farmer_in_the_land called for "+ self.get_land_name() +" with farmerArg: ")
	
	if farmer_arg != null:
		print(farmer_arg.get_farmer_name())
		_farmer_in_the_land = farmer_arg
	else:
		print("null")
		_farmer_in_the_land = null

	
func get_farmer_in_the_land() -> Sprite_farmer:
	return _farmer_in_the_land
	
	
func remove_farmer(farmer: Sprite_farmer) -> void:
	if _farmer_in_the_land == farmer:
		set_farmer_in_the_land(null)
	
	
func calculate_income_for_farmer(farmer: Sprite_farmer) -> float:
	return _farmer_productivity.get(farmer)
	

func set_current_rent(current_rent_arg: float) -> void:
	_current_rent = current_rent_arg
	$Label_currentRent.text = "Current Rent: " + str(current_rent_arg)
	
	
func get_current_rent() -> float:
	return _current_rent
	
	
func is_rented() -> bool:
	if null==_farmer_in_the_land:
		return false
	else:
		return true
	
	
func draw_incomes() -> void:
	var textOfIncomes = []
	for farmer in _farmer_productivity:
		if farmer != null:
			var textFarmer = farmer.get_farmer_name()
	
			var income = farmer.calculate_income_for_workplace(self)
			var incomeText = str(income)
			var textLine = textFarmer + ": " + incomeText
			textOfIncomes.append(textLine)
	var completeText = "Incomes:\n"
	for textLine in textOfIncomes:
		completeText += textLine + "\n"
	$Label_incomes.text = completeText
	
	
	

func _on_Button_tryToIncreaseRent_pressed():
	#todo
	#solo hace algo si ya tiene un propietario
	#la idea es subirle la renta, y ver si se largaría con la nueva renta
	if (_farmer_in_the_land):
		var current_rent_for_this_land: float = _current_rent;
		var param_increase_amount: float = 0.1;
		var increased_rent_for_this_land: float = current_rent_for_this_land + param_increase_amount;
		
		var current_farmer_of_this_land: Sprite_farmer = _farmer_in_the_land
		
		
		#todo
		var this_land = self
		var current_house_of_farmer = current_farmer_of_this_land.get_living_place()
		var current_income_of_faremer = current_farmer_of_this_land.calculate_income_for_workplace_and_house(this_land, current_house_of_farmer)
		var decreased_income_of_farmer = current_income_of_faremer-param_increase_amount
		
		if decreased_income_of_farmer < 0.0:
			return # si la renta del inquilino va a estar por debajo de 0, está claro que no puede pagar mas
		else:
			#veamos si el inquilino se largaría a otro lugar
			if(false == _node_main_ref.is_a_different_land_with_better_income(this_land, decreased_income_of_farmer)):
				_current_rent = increased_rent_for_this_land
				return
			else:
				return


func set_node_main_ref(node_main_ref_arg: Node_Main) -> void:
	_node_main_ref = node_main_ref_arg

