extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Sprite_house

#var _house_name: String


#class_name Sprite_farmer
#var _owner_farmer: Sprite #Sprite_farmer
var _farmer_in_the_house: Sprite #Sprite_farmer
var _current_rent: float


# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reset() -> void:
	_farmer_in_the_house = null
	_current_rent = 0.0


func get_house_name() -> String:
	var parent_node = self.get_parent() # no sé por qué $Sprite_land no me funciona
	var sprite_land: Sprite = parent_node as Sprite
	return sprite_land.get_land_name()


func get_owner_farmer() -> Sprite:
	#var sprite_land: Sprite = $Sprite_land as Sprite
	var parent_node = self.get_parent() # no sé por qué $Sprite_land no me funciona
	var owner_of_the_land = parent_node.get_owner_farmer()
	return owner_of_the_land
	
func get_land() -> Sprite:
	var parent_node = self.get_parent() # no sé por qué $Sprite_land no me funciona
	return parent_node
	
func get_current_rent() -> float:
	return _current_rent
	

func set_current_rent(current_rent_arg: float) -> void:
	_current_rent = current_rent_arg
	#$Label_houseCurrentRent.text = "House-Rent: " + str(current_rent_arg)
	

func get_farmer_in_the_house() -> Sprite:
	return _farmer_in_the_house
	
	
func set_farmer_in_the_house(farmer_in_the_house_arg: Sprite) -> void:
	_farmer_in_the_house = farmer_in_the_house_arg
	#if null == farmer_in_the_house_arg:
	#	$Label_farmerInTheHouse.text = "Empty house"
	#else:		
	#	var farmer_in_the_house_name: String = farmer_in_the_house_arg.get_farmer_name()
	#	$Label_farmerInTheHouse.text = "In house: " + farmer_in_the_house_name
	#$Label_houseCurrentRent.text = "House-Rent: " + str(self._current_rent)
	
func get_cummuting_expenses_to(workplace_arg: Sprite) -> float:
	if null == workplace_arg:
		return 0.0
	else:
		var land_of_house: Sprite = self.get_parent()
		var land_of_work: Sprite = workplace_arg
		var land_of_house_pos: Vector2 = land_of_house.get_position()
		var land_of_work_pos: Vector2 = land_of_work.get_position()		
		var distance: float = land_of_house_pos.distance_to(land_of_work_pos)
		var commuting_coeficient: float = 0.01
		return distance*commuting_coeficient


func remove_farmer(farmer: Sprite) -> void:
	if _farmer_in_the_house == farmer:
		set_farmer_in_the_house(null)

func update_texts() -> void:
	if null == self._farmer_in_the_house:
		$Label_farmerInTheHouse.text = "Empty house"
	else:		
		var farmer_in_the_house_name: String = self._farmer_in_the_house.get_farmer_name()
		$Label_farmerInTheHouse.text = "In house: " + farmer_in_the_house_name
	$Label_houseCurrentRent.text = "House-Rent: " + str(self._current_rent)
	

func _on_Button_tryToIncreaseHouseRent_pressed():
	#todo
	#solo hace algo si ya tiene un propietario
	#la idea es subirle la renta, y ver si se largaría con la nueva renta
	if (self._farmer_in_the_house and self.get_owner_farmer() != self.get_farmer_in_the_house()):
		var current_rent_for_this_house: float = _current_rent;
		var param_increase_amount: float = 0.1;
		var increased_rent_for_this_house: float = current_rent_for_this_house + param_increase_amount;
		
		var current_farmer_of_this_house: Sprite_farmer = self.get_farmer_in_the_house()
		
		var land_of_house = get_land()
		
		var current_income_of_farmer = current_farmer_of_this_house.calculate_income_for_workplace_and_house(land_of_house, self)
		
		var decreased_income_of_farmer = current_income_of_farmer-param_increase_amount
			
		if decreased_income_of_farmer < 0.0:
			return # si la renta del inquilino va a estar por debajo de 0, está claro que no puede pagar mas
		else:
			#veamos si el inquilino se largaría a otro lugar. De momento no ponemos condiciones
			var node_main_ref = land_of_house.get_node_main_ref()
			if(false == node_main_ref.is_a_different_land_or_house_with_better_income(land_of_house, decreased_income_of_farmer)):
				set_current_rent(increased_rent_for_this_house)
				node_main_ref.calculate_incomes()
				node_main_ref.update_texts()
				return
			else:
				return


func _on_Button_decreaseHouseRent_pressed():
	var current_rent_for_this_house: float = _current_rent;
	var param_decrease_amount: float = 0.1;
	var decreased_rent_for_this_house: float = current_rent_for_this_house - param_decrease_amount;
	var land_of_house = get_land()
	var node_main_ref = land_of_house.get_node_main_ref()
	if decreased_rent_for_this_house>0:
		set_current_rent(decreased_rent_for_this_house)
		node_main_ref.calculate_incomes()
		node_main_ref.update_texts()
