extends Object
class_name StaticCommonToolClass

## 用于检查动态属性是否存在且不为null[br]
## _property:属性名
static func property_check_debug(_target: Object, _property: String) -> bool:
	if _property in _target:
		if _target.get(_property):
			return true
		else:
			return false
	else:
		push_warning("目标%s无指定属性%s" % [_target.name, _property])
		return false

## 检查对应脚本在载入资源时是否缺少属性，会忽略_ignore_properties中的属性[br]
## _self:节点，一般是脚本所在的节点
static func resource_property_check(_self: Object, _data: Resource, _ignore_properties: Array) -> bool:
	var _self_properties: Array = _self.get_script().get_property_list()
	for _property_inf in _self_properties:
		if _property_inf.name in _data or _property_inf.name in _ignore_properties or (_property_inf.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) == 0:
			# _property_inf.usage & PROPERTY_USAGE_SCRIPT_VARIABLE用于排除非引擎内建变量
			continue
		else:
			push_warning("缺少属性%s" % _property_inf.name)
			return false
	return true

## 用于检查读取的资源是否合法（不会检查取值范围）
static func resource_legal_check(_self: Object, _data: Resource, _ignore_properties: Array) -> bool:
	if not _data:
		push_warning("在节点%s中，未指定所需的资源文件" % _self.name)
		return false
	if not StaticCommonToolClass.resource_property_check(_self, _data, _ignore_properties):
		push_warning("对应资源文件中缺少属性")
		return false
	return true
