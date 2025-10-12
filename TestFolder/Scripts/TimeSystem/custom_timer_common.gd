# todo _process方法，change_points_signals_data方法
extends Node
class_name CustomTimerCommon
# 这个变量可以在使用时不赋值，也可以在new()的时候手动将“自己”传递进来，这是用于方便找到信号发出者是谁而设置的
# 在触发信号时，会将这个值当做额外的参数传过去
var script_obj: CustomTimerCommon
var time: float
var timer_status: TimerEnums.Status = TimerEnums.Status.SLEEP:
    get:
        return timer_status
var end_time: float
var time_speed: float = 1
var emit_position_mode: TimerEnums.EmitPositionMode = TimerEnums.EmitPositionMode.NEAREST # 默认的触发类型，触发最近的和之前的时间节点的信号
var emit_repeat_mode: TimerEnums.EmitRepeatMode = TimerEnums.EmitRepeatMode.SINGLE
# 给时间节点使用的，时间到后的触发请使用另一个
#region
var signals_name: Array[String]
var signals_method_paras: Array[Array]: # 嵌套数组中必须有至少一个参数且为第一个参数，用于指定时间点，将按照时间点从小到大排序
    set(_params):
        time_points_sort()
        signals_method_paras = _params
var signals_emit_repeat_mode: Array[TimerEnums.EmitRepeatMode]
var signals_emit_state: Array[TimerEnums.EmitStateus]
#endregion
# 时间到末尾时的信号
#region
var signal_for_timeout_name: String
var signal_for_timeout_method_paras: Array
var signal_for_timeout_emit_repeat_mode: TimerEnums.EmitRepeatMode
var signal_for_timeout_emit_state: TimerEnums.EmitStateus = TimerEnums.EmitStateus.READY
#endregion

func _process(_delta: float) -> void:
    if timer_status in [TimerEnums.Status.SLEEP, TimerEnums.Status.READY, TimerEnums.Status.PAUSED, TimerEnums.Status.ENDED]:
        return
    if time >= end_time:
        if signal_for_timeout_emit_state == TimerEnums.EmitRepeatMode.SINGLE:
            emit_signal(signal_for_timeout_name, signal_for_timeout_method_paras, script_obj)
            timer_status = TimerEnums.Status.ENDED
        emit_signal(signal_for_timeout_name, signal_for_timeout_method_paras, script_obj)
    if timer_status == TimerEnums.Status.PROCESSING:
        calculate_time(_delta)
    if time <= 0:
        time = 0;
        push_warning("时间不能小于0，因此将被设回0")

func _init(_end_time: float) -> void:
    end_time = _end_time
    timer_status = TimerEnums.Status.READY

func reset_timer_to_time(_time: float) -> bool:
    if time <= end_time:
        _init(_time)
        return true
    return false
    
func start_timer() -> bool:
    if timer_status == TimerEnums.Status.READY:
        timer_status = TimerEnums.Status.PROCESSING
        return true
    return false

func calculate_time(_time_interval: float) -> void:
    time += _time_interval * Engine.time_scale * time_speed

func pause_timer() -> bool:
    if timer_status != TimerEnums.Status.ENDED or timer_status != TimerEnums.Status.READY:
        timer_status = TimerEnums.Status.PAUSED
        return true
    return false

func continue_timer() -> bool:
    if timer_status == TimerEnums.Status.PAUSED:
        timer_status = TimerEnums.Status.PROCESSING
        return true
    return false

func time_points_sort() -> void:
    var _nums: Array[float] = []
    var _indexes: Array[int] = []
    var _sorted_array: Array[Array] = []
    var _sorted_signals_emit_repeat_mode: Array[TimerEnums.EmitRepeatMode] = []
    var _sorted_signals_emit_state: Array[TimerEnums.EmitStateus] = []
    if not signals_method_paras:
        var _loop: int = 0
        for _paras in signals_method_paras:
            for _num in _paras:
                _nums.append(_num)
                _indexes.append(_loop)
                _loop += 1
        # 冒泡排序部分
        for _i in range(_nums.size() - 1):
            for _j in range(_nums.size() - 1 - _i):
                if _nums[_j] > _nums[_j + 1]:
                    var _temp_num := _nums[_j]
                    var _temp_index := _indexes[_j]
                    _nums[_j] = _nums[_j + 1]
                    _indexes[_j] = _indexes[_j + 1]
                    _nums[_j + 1] = _temp_num
                    _indexes[_j + 1] = _temp_index
        for _index in _indexes:
            _sorted_array.append(signals_method_paras[_index])
            _sorted_signals_emit_repeat_mode.append(signals_emit_repeat_mode[_index])
            _sorted_signals_emit_state.append(signals_emit_state[_index])
        signals_method_paras = _sorted_array
        signals_emit_repeat_mode = _sorted_signals_emit_repeat_mode
        if _sorted_signals_emit_state.size() <= signals_emit_state.size():
            signals_emit_state = _sorted_signals_emit_state
        else:
            signals_emit_state = _sorted_signals_emit_state
            while true:
                if _sorted_signals_emit_state.size() - signals_emit_state.size() <= 0:
                    break
                else:
                    signals_emit_state.append(TimerEnums.EmitStateus.READY)
        return
    else:
        push_warning("%s节点的计时器的信号参数列表为空，将不再排序" % self.name)
        return

# 第一次使用时请不要忽略传入_signals_name的值
func change_points_signals_data(_signals_method_paras: Array[Array], _signals_emit_repeat_mode: Array[TimerEnums.EmitRepeatMode]\
, _signals_name: Array[String] = []) -> void:
    var _time_check_resu: bool
    var _time_point_original: Array[float] = []
    var _time_point_input: Array[float] = []
    if not _signals_method_paras:
        for _params in signals_method_paras:
            _time_point_original.append(_params[0])
        for _params in _signals_method_paras:
            _time_point_input.append(_params[0])
        _time_point_input.sort()
        if _time_point_original != _time_point_input:
            pass # todo
    if not _signals_name == []:
        signals_name = _signals_name
    signals_method_paras = _signals_method_paras
    signals_emit_repeat_mode = _signals_emit_repeat_mode
    time_points_sort()

func check_and_reset_signals_emit() -> void:
    pass
