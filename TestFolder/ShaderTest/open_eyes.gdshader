shader_type canvas_item;
uniform sampler2D gradient_texture: source_color;
uniform float blur: hint_range(0.0, 100);
uniform float eye_process: hint_range(0.0, 1.0);
uniform float sp_value; // 用于决定模糊边长度
varying vec2 uv_offset;
// 思路：
float spec_func(float process){
	if(process <= blur && process >= -blur){
		return abs(sin(process * blur));
	}
	else{
		return 1.0f;
	}
}
void vertex() {
	uv_offset = UV - vec2(0.5, 0.5);
	// Called for every vertex the material is visible on.
}

void fragment() {

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
