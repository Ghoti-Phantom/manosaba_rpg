shader_type canvas_item;

uniform float open_amount : hint_range(0.0, 2) = 0.0; // 控制眼睛睁开程度
uniform float softness : hint_range(0.0, 0.4) = 0.05;    // 边缘柔和度
uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // 将UV映射到 -1~1
    
    // 椭圆公式：x²/a² + y²/b² <= 1
    float a = mix(0, 1.0, open_amount); // 横向半径
    float b = mix(0, 1.0, open_amount); // 纵向半径（闭眼时近似一条线）
    float ellipse = (uv.x*uv.x)/(a*a) + (uv.y*uv.y)/(b*b);

    // ellipse < 1 表示在眼睛开口区域
    float mask = 1.0 - smoothstep(1.0 - softness, 1.0 + softness, ellipse);

    vec4 tex_color = texture(screen_texture, SCREEN_UV);
    COLOR = mix(vec4(0.0, 0.0, 0.0, 1.0), tex_color, mask);
}
