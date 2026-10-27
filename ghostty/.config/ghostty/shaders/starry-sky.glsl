// Ghostty Custom Shader: Ultra-Dark Starry Sky & 60s Meteor
// Tuned for razor-sharp optical star clarity and crisp terminal text

// --- Configuration ---
const vec3 spaceBaseColor        = vec3(0.018, 0.020, 0.032); // Deep obsidian void
const float starDensity           = 0.78;                      // Star density (higher = fewer stars)
const float driftSpeed           = 0.010;                      // Gentle celestial drift
const float twinkleSpeed         = 2.2;                        // Star pulse rate
const float shootingStarInterval = 60.0;                       // Shooting star every 60 seconds (1 min)
const float shootingStarDuration = 1.2;                        // Duration of streak in seconds

// Hash for pseudo-random star distribution
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Single star layer with optical pinpoint clarity and crisp twinkling
vec3 renderStarLayer(vec2 uv, float seed, float scale, bool allowSpikes) {
    vec3 col = vec3(0.0);
    vec2 grid = uv * scale;
    vec2 id = floor(grid);
    vec2 st = fract(grid) - 0.5;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 offset = vec2(float(x), float(y));
            float n = hash21(id + offset + seed);

            if (n > starDensity) {
                vec2 starPos = offset + (vec2(hash21(id + offset + 1.2), hash21(id + offset + 3.4)) - 0.5) * 0.75;
                vec2 delta = st - starPos;
                float d = length(delta);
                float distSq = dot(delta, delta);

                // Twinkle cycle with high dynamic range
                float rawTwinkle = sin(iTime * (twinkleSpeed + n * 4.0) + n * 6.2831) * 0.5 + 0.5;
                float twinkle = pow(rawTwinkle, 1.4);
                float pulse = mix(0.25, 1.35, twinkle);

                // --- Optical Pinpoint Core (Inverse-Square PSF) ---
                // Highly concentrated in a sharp 1-2 pixel center
                float coreRadius = 0.00014;
                float core = coreRadius / (distSq + 0.00009) * pulse;

                // Steep exponential halo (drops off sharply, zero fuzzy blur)
                float halo = exp(-d * 42.0) * (0.28 * pulse);
                float brightness = core + halo;

                // Ultra-thin 1-pixel cross flare on brightest stars
                if (allowSpikes && n > 0.90 && twinkle > 0.6) {
                    float spikeIntensity = (twinkle - 0.6) * 2.5;
                    float ax = abs(delta.x);
                    float ay = abs(delta.y);
                    float spikeX = max(0.0, 1.0 - ay * 160.0) * max(0.0, 1.0 - ax * 12.0);
                    float spikeY = max(0.0, 1.0 - ax * 160.0) * max(0.0, 1.0 - ay * 12.0);
                    brightness += (spikeX + spikeY) * spikeIntensity;
                }

                // Natural spectral star tint (icy blue, warm gold, pure white)
                vec3 starColor = mix(vec3(0.75, 0.88, 1.0), vec3(1.0, 0.94, 0.80), n);
                col += starColor * brightness * (0.9 + n * 0.6);
            }
        }
    }
    return col;
}

// --- Procedural Meteor (Shooting Star) ---
// Runs once every shootingStarInterval seconds (60 seconds)
// O(1) early exit: zero GPU cost during inactive 58.8 seconds
vec3 renderShootingStar(vec2 uv, float time) {
    float cycle = floor(time / shootingStarInterval);
    float t = mod(time, shootingStarInterval);

    if (t > shootingStarDuration) return vec3(0.0);

    float progress = t / shootingStarDuration;

    float rand1 = hash21(vec2(cycle, 1.47));
    float rand2 = hash21(vec2(cycle, 8.93));
    float rand3 = hash21(vec2(cycle, 4.19));

    vec2 start = vec2((rand1 - 0.5) * 2.2, 0.25 + rand2 * 0.35);
    float dirX = (rand3 > 0.5) ? 1.0 : -1.0;
    vec2 dir = normalize(vec2(dirX * (0.8 + rand2 * 0.5), -(0.4 + rand1 * 0.5)));

    float pathLength = 1.6 + rand1 * 0.6;
    vec2 head = start + dir * (progress * pathLength);
    float tailLength = 0.35 + rand2 * 0.25;

    vec2 delta = uv - head;
    float along = dot(delta, -dir);
    float perpSq = dot(delta, delta) - along * along;

    vec3 col = vec3(0.0);

    // Glowing head flare
    float headDistSq = dot(delta, delta);
    float headGlow = exp(-headDistSq * 1800.0) * 2.2;
    col += vec3(1.0, 0.98, 0.95) * headGlow;

    // Glowing ionization trail
    if (along > 0.0 && along < tailLength && perpSq >= 0.0) {
        float perp = sqrt(perpSq);
        float trailFade = (1.0 - along / tailLength);
        trailFade *= trailFade;
        float trailWidth = 0.0012 + 0.0028 * (along / tailLength);
        float trail = smoothstep(trailWidth, 0.0, perp) * trailFade;

        vec3 trailColor = mix(vec3(1.0, 0.98, 0.90), vec3(0.4, 0.75, 1.0), along / tailLength);
        col += trailColor * trail * 3.2;

        float halo = smoothstep(trailWidth * 6.0, 0.0, perp) * trailFade * 0.4;
        col += vec3(0.3, 0.65, 1.0) * halo;
    }

    return col;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Aspect-corrected UV
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow celestial drift
    vec2 drift = vec2(iTime * driftSpeed, iTime * driftSpeed * 0.35);

    // Deep space gradient (almost pure black, very subtle indigo depth at bottom)
    vec3 space = spaceBaseColor + vec3(0.008, 0.012, 0.025) * (1.0 - uv.y);

    // 3 Parallax Star Layers (Pinpoint Micro, Mid-Range, Foreground Crisp Stars)
    space += renderStarLayer(uv + drift * 0.3, 11.23, 45.0, false) * 0.60; // Micro pinprick stars
    space += renderStarLayer(uv + drift * 0.6, 27.81, 28.0, false) * 1.00; // Mid-range sharp stars
    space += renderStarLayer(uv + drift * 1.0, 44.59, 14.0, true)  * 1.45; // Foreground crisp stars + micro spikes

    // Periodic Shooting Star (once every 60 seconds)
    space += renderShootingStar(uv, iTime);

    // --- Ghostty Terminal Text & UI Integration ---
    vec2 textUv = fragCoord.xy / iResolution.xy;
    vec4 terminal = texture(iChannel0, textUv);

    // Detect terminal text and UI elements against the default background
    float isText = smoothstep(0.02, 0.12, length(terminal.rgb - iBackgroundColor));
    vec3 finalColor = mix(space, terminal.rgb, max(isText, terminal.a));

    fragColor = vec4(finalColor, 1.0);
}
