varying vec2 vUv;
uniform float uTime;

#define NUM_OCTAVES 6

// ====================
vec3 darkColor = vec3( 0,  0,  1) / 255.0;
vec3 lightColor = vec3( 25,  25, 50) / 255.0;
vec3 accentColor1 = vec3(30, 30, 70) / 255.0;
vec3 accentColor2 = vec3( 100,  100, 120) / 255.0;

float intensityMain = 0.5;
float intensityAccent1 = 0.3;
float intensityAccent2 = 0.5;
// ==========================

float random(vec2 position) {
    return fract(sin(dot(position.xy, vec2(13.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 position) {
    vec2 gridIndex = floor(position);
    vec2 gridFraction = fract(position);

    float topLeft = random(gridIndex + vec2(0.0, 0.0));
    float topRight = random(gridIndex + vec2(1.0, 0.0));
    float bottomLeft = random(gridIndex + vec2(0.0, 1.0));
    float bottomRight = random(gridIndex + vec2(1.0, 1.0));

    vec2 smoothFraction = gridFraction * gridFraction * (3.0 - 2.0 * gridFraction);

    return mix(topLeft, topRight, smoothFraction.x) +
           (bottomLeft - topLeft) * smoothFraction.y * (1.0 - smoothFraction.x) +
           (bottomRight - topRight) * smoothFraction.x * smoothFraction.y;
}

float fbm(vec2 position) {
    float value = 0.0;
    float amplitude = 0.5;
    vec2 shift = vec2(100.0);
    mat2 rotation = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));

    for (int i = 0; i < NUM_OCTAVES; i++) {
        float direction = mod(float(i), 2.0) > 0.5 ? 1.0 : -1.0;
        value += amplitude * noise(position - 0.05 * direction * uTime);
        position = rotation * position * 2.0 + shift;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    vec2 uv = vUv;
    vec2 position = (uv * 3.0 - 0.5) * 2.0;
    position -= vec2(12.0, 0.0);

    vec2 flowField = vec2(0.0);
    flowField.x = fbm(position + 0.00 * uTime);
    flowField.y = fbm(position + vec2(1.0));

    vec2 warpField = vec2(0.0);
    warpField.x = fbm(position + 1.0 * flowField + vec2(1.7, 1.2) + 0.15 * uTime);
    warpField.y = fbm(position + 1.0 * flowField + vec2(8.3, 2.8) + 0.126 * uTime);

    float noiseValue = fbm(position + warpField);

    vec3 finalColor = mix(darkColor, lightColor, clamp(noiseValue * noiseValue * intensityMain, 0.0, 1.0));
    finalColor = mix(finalColor, accentColor1, clamp(length(flowField) * intensityAccent1, 0.0, 1.0));
    finalColor = mix(finalColor, accentColor2, clamp(length(warpField.x) * intensityAccent2, 0.0, 1.0));
    finalColor = (noiseValue * noiseValue * noiseValue * 0.3 + 0.2 + 0.9 * noiseValue) * finalColor;

    gl_FragColor = vec4(finalColor, 1.0);
}