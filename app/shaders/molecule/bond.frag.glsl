varying vec3 vNormal;
varying vec3 vPosition;
uniform float uTime;
uniform float uOpacity;
uniform float uBrightness;

void main() {
    float r = sin(vPosition.x * 4.0 + uTime) * 0.5 + 0.5;
    float g = sin(vPosition.y * 4.0 + uTime * 0.7 + 2.0) * 0.5 + 0.5;
    float b = sin(vPosition.z * 4.0 + uTime * 1.3 + 4.0) * 0.5 + 0.5;

    r = r < 0.5 ? 1.0 - r : r;
    g = g < 0.5 ? 1.0 - g : g;
    b = b < 0.5 ? 1.0 - b : b;

    vec3 color = vec3(r, g, b) * 0.7;
    color *= uBrightness;
    float alpha = uOpacity;

    gl_FragColor = vec4(color, alpha);
}