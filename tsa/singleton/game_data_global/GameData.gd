extends Node


signal balance_changed(new_balance)


var active_units = []
var active_commrades = []
var active_enemies = []
var balance: int


func get_active_units():
	return active_units


func get_active_commrades():
	return active_commrades
	

func get_active_enemies():
	return active_enemies


func get_balance():
	return balance


func change_balance(value, operation):
	if operation == "add" :
		balance += value
	elif operation == "subtract":
		balance -= value
	elif  operation == "divide":
		balance /= value
	elif operation == "multiply":
		balance *= value

	balance_changed.emit(balance)
