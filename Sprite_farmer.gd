extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

class_name Sprite_farmer

signal bid_made #se emite en _on_Button_bid_pressed

#export var _min_income: float = 10 #Todo. Tengo dudas de que todo lo relacionado con _min_income esté bien
var _current_income: float = 0
var _owned_lands: Array = []
#var _rented_lands: Array = []
var _default_position: Vector2

#class_name Sprite_land
var _workplace: Sprite # debería ser Sprite_land. Pero hay un problema de referencias cruzadas

var _living_place: Sprite #debería ser Sprite_house
var _owned_houses: Array = [] #Array de Sprite_house


#class_name Node_Main
var _node_main_ref: Node_Main


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset() -> void:
	_current_income = 0.0
	_workplace = null
	_living_place = null
	set_position(_default_position)


func add_owned_land(land: Sprite) -> void:
	if false == (land in _owned_lands):
		_owned_lands.append(land)


func remove_owned_land(land: Sprite) -> void:
	if land in _owned_lands:
		_owned_lands.erase(land)

func is_owned_land(land: Sprite) -> bool:
	if land in _owned_lands:
		return true
	else:
		return false
		
func is_owned_house(house: Sprite) -> bool:
	if house in _owned_houses:
		return true
	else:
		return false

func calculate_income() -> float:
#	var income_from_rented_lands = calculate_income_from_rented_lands()
#	var income_from_work = calculate_income_from_work()
#	var expenses_from_rented_lands = calculate_expenses_from_rented_lands_for_workplace(_workplace)
#	var expenses_from_rented_house = calculate_expenses_from_rented_houses()
#	var expenses_from_commuting = calculate_expenses_from_commuting()
#	var income_from_rented_house = calculate_income_from_rented_houses()
#	var total_income = 0.0
#	total_income = (income_from_rented_lands + income_from_work - expenses_from_rented_lands +
#			expenses_from_rented_house + expenses_from_commuting + income_from_rented_house)
#	return total_income
	return calculate_income_for_workplace_and_house(_workplace, _living_place)


func calculate_expenses_from_rented_houses(living_place_arg: Sprite) -> float:
	if null != living_place_arg:
		if self != living_place_arg.get_owner_farmer():
			return living_place_arg.get_current_rent()
	return 0.0
	
	
func calculate_income_from_rented_houses(living_place_arg: Sprite) -> float:
	var total_income: float = 0.0
	for house in _owned_houses:		
		if house !=living_place_arg:
			var income: float = house.get_current_rent()
			total_income += income
	return total_income


func calculate_expenses_from_commuting(workplace_arg: Sprite, living_place_arg: Sprite) -> float:
	if null == living_place_arg || null == workplace_arg:
		return 0.0
	else:
		return living_place_arg.get_cummuting_expenses_to(workplace_arg)


#func calculate_income_from_work() -> float:
#	return calculate_income_from_work_for_workplace(_workplace)


#func calculate_expenses_from_rented_lands() -> float:
#	return calculate_expenses_from_rented_lands_for_workplace(_workplace)

func calculate_income_for_workplace(workplace_arg: Sprite) -> float:
	
	if null == workplace_arg:
		return 0.0
	else:
		var income_from_rented_lands = calculate_income_from_rented_lands_for_workplace(workplace_arg)
		var income_from_work: float = calculate_income_from_work_for_workplace(workplace_arg)
		var expenses_from_rented_lands = calculate_expenses_from_rented_lands_for_workplace(workplace_arg)

		var total_income = 0.0
		total_income = (income_from_rented_lands + income_from_work - expenses_from_rented_lands)
		return total_income

func calculate_income_for_workplace_and_house(workplace_arg: Sprite, living_place_arg: Sprite) -> float:
	
	if null == living_place_arg || null == workplace_arg:
		return 0.0
	else:
		
		var income_from_rented_lands = calculate_income_from_rented_lands_for_workplace(workplace_arg)
		var income_from_work: float = calculate_income_from_work_for_workplace(workplace_arg)
		var expenses_from_rented_lands = calculate_expenses_from_rented_lands_for_workplace(workplace_arg)
		var expenses_from_rented_house = calculate_expenses_from_rented_houses(living_place_arg)
		var expenses_from_commuting = calculate_expenses_from_commuting(workplace_arg, living_place_arg)
		var income_from_rented_house = calculate_income_from_rented_houses(living_place_arg)
		var total_income = 0.0
		total_income = (income_from_rented_lands + income_from_work - expenses_from_rented_lands -
				expenses_from_rented_house - expenses_from_commuting + income_from_rented_house)			
		return total_income

	
func calculate_income_from_work_for_workplace(workplace_arg: Sprite) -> float:
	if null != workplace_arg:
		var income_in_workplace: float = workplace_arg.calculate_income_for_farmer(self)
		if null != income_in_workplace:
			return income_in_workplace
		else:
			return 0.0
	else:
		return 0.0
#	else:
#		return _min_income #No sé por qué tengo esto puesto aquí


func calculate_income_from_rented_lands_for_workplace(workplace_arg: Sprite) -> float:
	print("farmer: " + get_farmer_name())
	var total_income = 0.0
	for owned_land in _owned_lands:
		if owned_land.is_rented() and owned_land.get_farmer_in_the_land() != self and owned_land != workplace_arg:
			print("land with farmer: " + owned_land.get_land_name())
			print("farmer in the Land: " + owned_land.get_farmer_in_the_land().get_farmer_name())
			total_income += owned_land.get_current_rent()
	return total_income


func calculate_expenses_from_rented_lands_for_workplace(workplace_arg: Sprite):
	if workplace_arg in _owned_lands:
		return 0.0
	else:
		if null == workplace_arg:
			return 0.0
		else:
			return workplace_arg.get_current_rent()


func set_farmer_name(name: String) -> void:
	$Label_name.text = name 


func get_farmer_name() -> String:
	return $Label_name.text


#func get_min_income() -> float:
#	return self.-


#func set_min_income(min_income_arg: float) -> void:
#	self._min_income = min_income_arg
#	$Label_minIncome.text = str(min_income_arg)


func get_current_income() -> float:
	return self._current_income


func set_current_income(current_income_arg: float) -> void:
	self._current_income = current_income_arg
	#$Label_currentIncome.text = str(current_income_arg)



func set_node_main_ref(node_main_ref_arg: Node_Main) -> void:
	_node_main_ref = node_main_ref_arg


func set_default_position(default_position_arg: Vector2) -> void:
	_default_position = default_position_arg


func get_default_position() -> Vector2:
	return _default_position


func update_position() -> void:
	if _workplace == null:
		set_position(_default_position)
	else:		
		var position = _workplace.get_position()
		position.x += -110
		set_position(position)


func set_workplace(workplace_arg: Sprite) -> void:
	print("set_work_place called for " + self.get_farmer_name())
	var oldWorkPlace = _workplace
	if _workplace != workplace_arg:		
		if null != oldWorkPlace:			
			oldWorkPlace.set_farmer_in_the_land(null)
		else:
			print("oldWorkPlace is null")
	else:
		print("_workplace == workplace_arg")
	if null != workplace_arg:
		print("workplace_arg is: " + workplace_arg.get_land_name())
		var old_farmer_of_the_land = workplace_arg.get_farmer_in_the_land()		
		if null != old_farmer_of_the_land:
			print("oldFarmerOfTheLand is " + old_farmer_of_the_land.get_farmer_name())
			old_farmer_of_the_land.set_workplace(null)
			old_farmer_of_the_land.update_position()
		else:
			print("oldFarmerOfTheLand is null")
		workplace_arg.set_farmer_in_the_land(self)
		_workplace = workplace_arg
		update_position()
	else:
		print("workplace_arg is null")
		_node_main_ref.remove_farmer_from_all_lands(self)
		_workplace = workplace_arg
		update_position()


func set_living_place(living_place_arg: Sprite):
	#_living_place = living_place_arg
	
	print("set_living_place called for " + self.get_farmer_name())
	var old_living_place = _living_place
	if _living_place != living_place_arg:		
		if null != old_living_place:			
			old_living_place.set_farmer_in_the_house(null)
		else:
			print("old_living_place is null")
	else:
		print("_living_place == living_place_arg")
	
	if null != living_place_arg:
		print("living_place_arg is: " + living_place_arg.get_house_name())
		var old_farmer_of_the_land = living_place_arg.get_farmer_in_the_house()		
		if null != old_farmer_of_the_land:
			print("old_farmer_of_the_land is " + old_farmer_of_the_land.get_farmer_name())
			old_farmer_of_the_land.set_living_place(null)
			#old_farmer_of_the_land.update_position()
		else:
			print("old_farmer_of_the_land is null")
		living_place_arg.set_farmer_in_the_house(self)
		_living_place = living_place_arg		
	else:
		print("living_place_arg is null")
		_node_main_ref.remove_farmer_from_all_houses(self)
		_living_place = living_place_arg
		#update_position()
	
	

func get_living_place() -> Sprite:
	return _living_place

func _on_Button_bid_pressed():
	#Primero, se busca el terreno y la casa donde se maximiza el beneficio
	var lands = _node_main_ref.get_lands()
	var houses = _node_main_ref.get_houses()
	var land_with_max_income
	var house_with_max_income: Sprite #debería ser Sprite_house
	var max_income = 0.0
	for land in lands:
		for house in houses:
			var income_for_land = calculate_income_for_workplace_and_house(land, house)
			if income_for_land > max_income:
				max_income = income_for_land
				land_with_max_income = land
				house_with_max_income = house

	#Si el beneficio es mayor que el incremento de renta de casa y tierra que vamos a proponer, 	
	var new_increase_in_rent_of_land = 0.1
	var new_increase_in_rent_of_house = 0.1
	if max_income > new_increase_in_rent_of_land + new_increase_in_rent_of_house : # Quizá, debería poner la condición de que sea mayor que 0.2
		#se hace el cambio de terreno, (si no estaba ya allí) y se añade 0.1 a la renta que se paga		
		var old_farmer_of_the_land = land_with_max_income.get_farmer_in_the_land()
		if old_farmer_of_the_land != self:
			set_workplace(land_with_max_income)
			var old_rent = land_with_max_income.get_current_rent()
			var new_rent = old_rent + new_increase_in_rent_of_land
			if is_owned_land(land_with_max_income):
				new_rent = old_rent #No aumenta la renta de la propiedad, si nosotros somos los dueños
			land_with_max_income.set_current_rent(new_rent)
			
		#se hace el cambio de casa, (si no estaba ya allí), y se añade 0.1 a la renta que se paga				
		var old_farmer_of_the_house = house_with_max_income.get_farmer_in_the_house()
		if old_farmer_of_the_house != self:
			set_living_place(house_with_max_income)
			var old_rent = house_with_max_income.get_current_rent()
			var new_rent = old_rent + new_increase_in_rent_of_house
			if old_farmer_of_the_land == old_farmer_of_the_house:
				new_rent = old_rent # Si acabamos de dejar sin trabajo al farmer q ocupa la casa, entonces no hace falta mejorar su alquiler
			if is_owned_house(house_with_max_income): #si la casa es nuestra, no hay que aumentar la renta
				new_rent = old_rent 
			house_with_max_income.set_current_rent(new_rent)
	
	emit_signal("bid_made")

func update_texts() -> void:
	$Label_currentIncome.text = str(self._current_income)
	var expenses_from_commuting = 0
	if null != self._workplace and null != self._living_place:
		expenses_from_commuting = calculate_expenses_from_commuting(self._workplace,self._living_place)
		
	$Label_commutExpenses.text = str(expenses_from_commuting)