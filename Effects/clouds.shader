shader_type canvas_item;

uniform float scroll_speed = 4.0;

float hash1(vec2 p)
{
    p  = 50.0 * fract(p * 0.3183099);
    return fract(p.x * p.y * (p.x + p.y));
}

float noise(vec2 x)
{
    vec2 p = floor(x);
    vec2 w = fract(x);
    vec2 u = w * w * (3.0 - 2.0 * w);

    float a = hash1(p + vec2(0, 0));
    float b = hash1(p + vec2(1, 0));
    float c = hash1(p + vec2(0, 1));
    float d = hash1(p + vec2(1, 1));
    
    return -1.0 + 2.0 * (a + (b - a) * u.x + (c - a) * u.y + (a - b - c + d) * u.x * u.y);
}

float fbm(vec2 x)
{
    mat2 m2 = mat2(vec2(0.80, 0.60), vec2(-0.60,  0.80));

    float f = 1.9;
    float s = 0.55;
    float a = 0.0;
    float b = 0.5;

    for (int i = 0; i < 9; i++)
    {
        float n = noise(x);
        a += b * n;
        b *= s;
        x = f * m2 * x;
    }

	return a;
}


vec4 blend_over(vec4 top, vec4 bottom) {
    vec3 col = top.rgb * top.a + bottom.rgb * bottom.a * (1. - top.a);
    float a = top.a + bottom.a * (1. - top.a);
    return vec4(col, a);
}


void fragment() {
    vec2 shifteduv = UV * 4.0;
    vec2 shifteduv2 = UV * 4.0;
    shifteduv.y -= TIME * scroll_speed;
    shifteduv2.y -= TIME * scroll_speed * 2.0;
    shifteduv2.x += TIME * scroll_speed * 0.04;

    float n1 = fbm(shifteduv);
    float n2 = fbm(shifteduv2);

    n1 = mix(n1, n2, 0.8);

    vec2 lowerduv = UV * 12.0;
    lowerduv.y -= TIME * scroll_speed / 3.0;
    float lower_n = fbm(lowerduv) ;

    //lower_n = mix(lower_n, fbm(lowerduv * 0.9 + vec2(-0.1 * TIME * scroll_speed,  0.1 * TIME * scroll_speed)), 0.1);

    vec2 shadowdec = lowerduv + vec2(0.7, 0.2) + vec2(0.05) * fbm(UV * 12.0);
    float shadow = fbm(shadowdec);
    //shadow = mix(shadow, fbm(lowerduv * 0.9 + vec2(-0.1 * TIME * scroll_speed,  0.1 * TIME * scroll_speed)), 0.1);
    
    n1 = smoothstep(0.0, 0.6, n1);
    lower_n = smoothstep(0.0, 0.75, lower_n);
    shadow = smoothstep(0.0, 0.75, shadow) * 0.6;
    
    float n3 = 1. - ((1. - n1) * (1. - lower_n));

    vec3 shadow_col = vec3(0.0);
    vec3 cloud_col = vec3(1.0);
    float alpha = n3 + shadow * (1.-n3);

    COLOR = blend_over(vec4(cloud_col, n3), vec4(shadow_col, shadow));
}