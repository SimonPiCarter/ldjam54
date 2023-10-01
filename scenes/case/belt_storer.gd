class_name BeltStorer extends Belt

@export var storage_next : Storage = null

func progress():
	if next:
		if not next.next_package and package:
			next.next_package = package
			package = null
	elif package:
		stored_package.emit(package, storage_next)
		package = null
