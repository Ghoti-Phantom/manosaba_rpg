extends Node
class_name TimerEnums
enum Status{
    SLEEP, # 未开始过也未初始化的状态
    READY, # 已经初始化过，但时间小于等于预定最大时间的状态
    PROCESSING, # 运行中的状态
    PAUSED,
    ENDED, # 计时大于等于预定最大时间的状态，且计时器停止，不再触发信号
}
enum EmitPositionMode{
    NEAREST, # 只触发最近的信号
    ALL # 触发所有时间节点内的信号
}
enum EmitRepeatMode{
    SINGLE, # 在计时器未reset之前，对应信号至多触发一次
    REPEAT
}
enum EmitStateus{
    READY, # 还没有触发的状态
    EMITED, # 触发后的状态，无论是否重复，只要触发过，在没有reset之前都是此状态
}