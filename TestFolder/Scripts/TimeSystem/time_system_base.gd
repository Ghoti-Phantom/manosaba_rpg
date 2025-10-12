extends Node
var timer1: CustomTimerCommon
var end_time: float
var time_point: Array[float]
var stages: int = 1
@export var data: Resource

func _init():
    if not StaticCommonToolClass.resource_legal_check(self, data, ["timer1, data, stages"]):
        return
    init_properties()
    timer1 = CustomTimerCommon.new(end_time)
    
func init_properties() -> void:
    pass

