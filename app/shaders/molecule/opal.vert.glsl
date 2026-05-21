varying vec3 vNormal;
varying vec3 vPosition;
varying vec2 vUv;
uniform float uTime;

#define MAX_ITER 4

void main() {

    vec3 sp = position.xyz * 2.5 - vec3(15.0);
    vec3 p = sp;
    vec3 i = p;
    float c = 1.0;
    float inten = 0.1;

    for (int n = 0; n < MAX_ITER; n++) {
        float t = 0.2 * uTime * (11.0 - (3.0 / float(n + 1)));
        i = p + vec3(
            cos(t - i.x) + sin(t + i.y),
            sin(t - i.y) + cos(t + i.z),
            cos(t - i.z) + sin(t + i.x)
        );
        c += 1.0 / length(vec3(
            p.x / (sin(i.x + t) / inten),
            p.y / (cos(i.y + t) / inten),
            p.z / (sin(i.z + t) / inten)
        ));
    }

    c /= float(MAX_ITER);
    c = 1.5 - sqrt(c);
    float wave = c * c * 0.12;

    vec3 newPosition = position + normal * wave;

    vNormal = normalize(normalMatrix * normal);
    vPosition = newPosition;
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
}