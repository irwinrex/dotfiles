// Ghostty Custom Shader: Ultra-Dark Starry Sky
// One star per grid cell. The glow dies inside the cell, so the 3x3
// neighbor walk is not needed.

// --- Configuration ---
const vec3 spaceBaseColor        = vec3(0.018, 0.020, 0.032); // Deep obsidian void
const float starThreshold        = 0.84;                       // 16% of cells get a star (higher = fewer)
const float driftSpeed           = 0.0040;                     // Gentle celestial drift (~4 px/s at 1000px)
const float twinkleSpeed         = 0.8;                        // Slow shimmer base rate
const float twinkleVariation     = 1.2;                        // Per-star shimmer variation
const float spikeThreshold       = 0.97;                       // Very few stars get cross flares

// Hash for pseudo-random star distribution
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// One optical pinpoint in the current cell. Inset so the halo stays inside it.
vec3 renderStarLayer(vec2 uv, float seed, float scale, bool allowSpikes) {
    vec3 col = vec3(0.0);
    vec2 grid = uv * scale;
    vec2 id = floor(grid);
    vec2 st = fract(grid) - 0.5;
    float presence = hash21(id + seed);

    if (presence > starThreshold) {
        // Decide looks independently from rarity so fewer stars still vary.
        float kind = hash21(id + vec2(7.13, 3.71) + seed);
        vec2 starPos = (vec2(
            hash21(id + vec2(1.2, 3.4) + seed),
            hash21(id + vec2(5.7, 9.1) + seed)
        ) - 0.5) * 0.62;
        vec2 delta = st - starPos;
        float distSq = dot(delta, delta);

        // Past the halo. Most of the cell exits before sin/exp.
        if (distSq < 0.16) {
            float tw = sin(iTime * (twinkleSpeed + kind * twinkleVariation) + kind * 6.2831) * 0.5 + 0.5;
            tw *= tw;
            float pulse = mix(0.55, 1.05, tw);

            // Inverse-square core (no sqrt) plus a short gaussian halo.
            float core = 0.00020 / (distSq + 0.00008) * pulse;
            float halo = exp(-distSq * 700.0) * (0.32 * pulse);
            float brightness = core + halo;

            // Thin cross flare on a few of the brightest foreground stars.
            if (allowSpikes && kind > spikeThreshold && tw > 0.55) {
                float spikeIntensity = (tw - 0.55) * 1.2;
                float ax = abs(delta.x);
                float ay = abs(delta.y);
                float spikeX = max(0.0, 1.0 - ay * 140.0) * max(0.0, 1.0 - ax * 14.0);
                float spikeY = max(0.0, 1.0 - ax * 140.0) * max(0.0, 1.0 - ay * 14.0);
                brightness += (spikeX + spikeY) * spikeIntensity;
            }

            // Icy blue through warm gold.
            vec3 starColor = mix(vec3(0.75, 0.88, 1.0), vec3(1.0, 0.94, 0.80), kind);
            col = starColor * brightness * (0.9 + kind * 0.6);
        }
    }

    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    vec2 drift = vec2(iTime * driftSpeed, iTime * driftSpeed * 0.35);

    // Deep void, slightly brighter indigo toward the lower sky.
    float lift = 1.0 - uv.y;
    vec3 space = spaceBaseColor + vec3(0.010, 0.014, 0.030) * lift;
    float band = uv.y + 0.12;
    space += vec3(0.015, 0.020, 0.045) * exp(-band * band * 4.0);

    space += renderStarLayer(uv + drift * 0.3, 11.23, 45.0, false) * 0.70;
    space += renderStarLayer(uv + drift * 0.6, 27.81, 28.0, false) * 1.05;
    space += renderStarLayer(uv + drift * 1.0, 44.59, 14.0, true)  * 1.50;

    vec2 textUv = fragCoord.xy / iResolution.xy;
    vec4 terminal = texture(iChannel0, textUv);
    float isText = smoothstep(0.02, 0.12, length(terminal.rgb - iBackgroundColor));
    vec3 finalColor = mix(space, terminal.rgb, max(isText, terminal.a));

    fragColor = vec4(finalColor, 1.0);
}
