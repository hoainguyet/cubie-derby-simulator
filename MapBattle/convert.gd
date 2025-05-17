class_name Convert extends Object



static func get_rank(value: int) -> String:
	match value % 10:
		1:
			if value % 100 == 11:
				return "11th"
			else:
				return str(value) + "st"
		2:
			if value % 100 == 12:
				return "12th"
			else:
				return str(value) + "nd"
		3:
			if value % 100 == 13:
				return "13th"
			else:
				return str(value) + "rd"
		_:
			return str(value) + "th"




