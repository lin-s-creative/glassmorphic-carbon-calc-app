varying vec3 vNormal;
varying vec3 vPosition;
uniform float uTime;
uniform vec3 uColorMultiply;
uniform float uOpacity;
uniform float uBrightness;

#define MAX_ITER 4

void main() {

    vec2 sp = vPosition.xy;
    vec2 p = sp * 4.0 - vec2(10.0);
    vec2 i = p;
    float c = 1.0;
    float inten = 0.01;

    for (int n = 0; n < MAX_ITER; n++) {
        float t = 0.2 * uTime * (11.0 - (3.0 / float(n + 1)));
        i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
        c += 1.0 / length(vec2(p.x / (sin(i.x + t) / inten), p.y / (cos(i.y + t) / inten)));
    }

    c /= float(MAX_ITER);
    c = 1.5 - sqrt(c);
    float wave = c * c * c * c;

    float r = sin((vPosition.x + wave * 0.3) * 4.0 + uTime) * 0.5 + 0.5;
    float g = sin((vPosition.y + wave * 0.3) * 4.0 + uTime * 0.7 + 2.0) * 0.5 + 0.5;
    float b = sin((vPosition.z + wave * 0.3) * 4.0 + uTime * 1.3 + 4.0) * 0.5 + 0.5;

    r = r < 0.5 ? 1.0 - r : r;
    g = g < 0.5 ? 1.0 - g : g;
    b = b < 0.5 ? 1.0 - b : b;

    vec3 baseColor = vec3(r, g, b);

    vec3 lightDir = normalize(vec3(0.5, 0.5, 0.7));
    float lighting = max(0.0, dot(vNormal, lightDir));
    float ambient = 0.3;
    vec3 litColor = baseColor * (ambient + lighting * 0.7);
    litColor += baseColor * 0.3;

    litColor = litColor * uColorMultiply;

    float fresnel = pow(1.0 - abs(dot(vNormal, vec3(0.0, 0.0, 1.0))), 3.0);
    vec3 reflection = vec3(0.7, 0.8, 1.0);
    litColor = mix(litColor, reflection, fresnel * 0.6);

    float alpha = 0.65 + fresnel * 0.9;

    litColor *= uBrightness;

    gl_FragColor = vec4(litColor, alpha * uOpacity);
}