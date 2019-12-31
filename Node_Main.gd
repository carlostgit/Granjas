extends Node

class_name Node_Main

#Lo de export tiene truco.
#Cuando pones algo como export, en el menú "Inspector" eliges qué contiene
#En el Inspector la variable aparece con espacios y mayúscula al comienzo de la palabra en vez de _ y minúsculas
#Atención! Para ver las variables del nodo en el Inspector, hay que clicar el nodo en el menú Scene!
export (PackedScene) var _sprite_farmer_ps #en el Inspector aparece automaticamente como Sprite Farmer Ps
export (PackedScene) var _sprite_land_ps #en el Inspector aparece automaticamente como Sprite Land Ps

export (PackedScene) var _sprite_land_2_ps #en el Inspector aparece automaticamente como Sprite Farmer Ps

var _farmers: Array = []
var _lands: Array = []

var _farmer_names: Array = ["Paco", "Pepe", "Patxi"]
var _land_names: Array = ["grass", "hilly", "hillyDesert"]

var _grass_res: Resource = preload("res://grass.png")
var _hilly_res: Resource = preload("res://hilly.png")
var _hilly_desert_res: Resource = preload("res://hillyDesert.png")
var _land_name_resource_dic: Dictionary = {"grass":_grass_res,"hilly":_hilly_res,"hillyDesert":_hilly_desert_res}

var _farmer_properties_dic: Dictionary = {"Pepe": ["grass","hilly"], "Paco":["hillyDesert"] }
#var _farmer_min_income_dic: Dictionary = {"Pepe": 0, "Paco":0, "Patxi":0} #Seria los ingresos por debajo de los cuales, no trabaja?
var _land_productivities_dic: Dictionary = {"grass":{"Paco":3, "Pepe":2, "Patxi":4}, 
		"hilly":{"Paco":3, "Pepe":3, "Patxi":3}, 
		"hillyDesert":{"Paco":1, "Pepe":2, "Patxi":1}}


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Inicializamos los nodos Sprite_land
	var count = 0
	for land_name in _land_names:
		
		
		#var land2 = _sprite_land_2_ps.instance() #devuelve un Node
		#land2.set_land_name("grass")
		
		#var sprite_land: Sprite_land = land2 as Sprite_land
		#sprite_land.set_land_name("grass")
		
		var land = _sprite_land_ps.instance() #devuelve un Node		
		var texture = _land_name_resource_dic.get(land_name) #devuelve un resource
		land.set_texture(texture) #al node Sprite_land (hereda de Sprite) se le asigna una textura
		land.set_land_name(land_name)
		#Les asignamos posiciones en la escena, (en columna hacia abajo)
		if(0 == count):
			land.set_position(Vector2(250,100))
		else:
			var y = _lands.back().get_position().y
			land.set_position(Vector2(250, y +80))
		#se inicializa la renta actual a 1, porque sí:
		land.set_current_rent(1.0)
		#Se le hace (al Sprite_land) hijo del Node_Main.
		#No recuerdo muy bien por qué se hace así, pero si no, no aparece en la escena
		add_child(land)
		#Lo añado al array de _lands
		_lands.append(land)
		count += 1
	
	#Inicializamos los nodos Sprite_farmer
	count = 0
	for far_name in _farmer_names:
		var farmer = _sprite_farmer_ps.instance() #Devuelve el nodo Sprite_farmer
		farmer.set_farmer_name(far_name)
		#var min_income:float = _farmer_min_income_dic.get(far_name)
		#farmer.set_min_income(min_income)	

		#Coloco los Sprite_farmer en una columna en vertical		
		var position = Vector2(30,200)
		if(0 != count):
			var y = _farmers.back().get_position().y			
			position = _farmers.back().get_position() + Vector2(0,80)
		farmer.set_position(position)		
		farmer.set_default_position(position)
		
		#Hago que aparezca el nombre del farmer, en las tierras de las que es dueño
		if(_farmer_properties_dic.has(far_name)):
			var properties = _farmer_properties_dic.get(far_name)
			for land_name in properties:			
				var land = get_land_from_name(land_name)
				farmer.add_owned_land(land)
				land.set_owner_farmer(farmer)

		#Le paso una referencia de Node_main, a los Sprite_farmer
		#Se necesitará para obtener referencias al array de _lands y _houses
		#para poder así estimar los ingresos que tendría en cada lugar		
		farmer.set_node_main_ref(self)
		farmer.connect("bid_made", self, "on_Sprite_farmer_bid_done")
		add_child(farmer)
		_farmers.append(farmer)
		count += 1
	
	for land_name in _land_names:
		var produc_dic_for_land = get_land_productivity_dict(land_name)
		var land = get_land_from_name(land_name)
		for farmer_name in produc_dic_for_land:
			var farmer = get_farmer_from_name(farmer_name)
			if null != farmer && null != land:
				land.set_farmer_productivity(farmer,produc_dic_for_land[farmer_name])
		land.set_node_main_ref(self)

	var farmer = get_farmer_from_name("Pepe")
	var land = get_land_from_name("hilly")
	farmer.set_workplace(land)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_land_from_name(land_name: String) -> Sprite:
	for land in _lands:
		if land.get_land_name()==land_name:
			return land
	return null


func get_farmer_from_name(farmer_name: String) -> Sprite:
	for farmer in _farmers:
		if farmer.get_farmer_name()==farmer_name:
			return farmer
	return null


func get_land_productivity_dict(land_name_arg: String) -> Dictionary:
	for land_name_of_dic in _land_productivities_dic:
		if land_name_of_dic == land_name_arg:
			var productivity_dic =  _land_productivities_dic[land_name_of_dic]
			return productivity_dic
	return {}
	
	
func remove_farmer_from_all_lands(farmer: Sprite) -> void:
	for land in _lands:
		land.remove_farmer(farmer)

func remove_farmer_from_all_houses(farmer: Sprite) -> void:
	for house in get_houses():
		house.remove_farmer(farmer)
	

func _on_Button_calculate_pressed():
	calculate_incomes()

func calculate_incomes() -> void:
	for farmer in _farmers:
		var income = farmer.calculate_income()
		farmer.set_current_income(income)
			
	for land in _lands:
		land.draw_incomes()

func _on_Button_reset_pressed():
	reset()


func get_lands() -> Array:
	return _lands


func get_houses() -> Array:
	var houses: Array
	for land in _lands:
		var house_of_the_land: Sprite = land.get_house()
		if null != house_of_the_land:
			houses.append(house_of_the_land)
	return houses

func reset() -> void:
#	var count = 0
#	var previousFarmer
#	for farmer in _farmers:	
#		if(0 == count):
#			farmer.set_position(Vector2(30,200))
#			farmer.set_default_position(Vector2(30,200))
#		else:
#			var y = previousFarmer.get_position().y
#			farmer.set_position(Vector2(30, y +80))		
#			farmer.set_default_position(Vector2(30, y +40))
#			
#		remove_farmer_from_all_lands(farmer)
#		previousFarmer = farmer
#		count += 1
#	
#	for land in _lands:
#		land.set_current_rent(0.0)
	for farmer in _farmers:
		farmer.reset()
	for land in _lands:
		land.reset()
	for house in get_houses():
		house.reset()
		
		
func on_Sprite_farmer_bid_done() -> void:
	print ("on_Sprite_farmer_bid_done() called")
	calculate_incomes()
	
	
func is_a_different_land_with_better_income(this_land: Sprite, decreased_income_for_this_land: float) -> bool:
	#print ("todo is_a_different_land_with_better_income called")
	#print ("debug this method")
	var farmer_in_this_land: Sprite = this_land.get_farmer_in_the_land()
	for land in get_lands():
		if land != this_land:
			for house in get_houses():
				var alternative_income: float = farmer_in_this_land.calculate_income_for_workplace_and_house(land,house)
				if alternative_income > decreased_income_for_this_land:
					return true;
	return false;