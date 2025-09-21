extends Node
class_name StaticCommonToolClass

static func property_check(node_with_script: Node, property_path: String) -> bool:
	if property_path in node_with_script:
		return true
	else:
		return false
		
static func property_check_debug(node_with_script: Node, property_path: String) -> bool:
	if property_path in node_with_script:
		return true
	else:
		push_warning("节点%s无指定路径%s的属性" % [node_with_script.name, property_path])
		return false
