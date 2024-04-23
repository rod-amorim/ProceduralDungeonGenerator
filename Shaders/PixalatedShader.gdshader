shader_type canvas_item;

uniform sampler2D screenTesture : hint_screen_texture, repeat_disable, filter_nearest;
global uniform int PixalationAmount : hint_range(0, 100, 1) = 0;

float inverseLerp (float a ,float b, float v){
	return (v - a) / (b-a);
}

float remap(float origFrom, float origTo, float targetFrom, float targetTo, float value){
  	float rel = (value - origFrom) / (origTo-origFrom);
  	return mix(targetFrom, targetTo, rel);
}

void fragment() {
	float remapValue = remap(0.0, 100.0, 512.0,64.0 , float(PixalationAmount));
	
	vec2 grid_uv = round(SCREEN_UV * float(remapValue)) / float(remapValue);
	
	vec4 text = texture(screenTesture, grid_uv);
	
	COLOR = text;
}