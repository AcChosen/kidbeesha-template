void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 centered = uv - 0.5;
    centered.x *= iResolution.x / iResolution.y;

    float radius = 0.3;
    float dist = length(centered);
    float circle = smoothstep(radius + 0.01, radius - 0.01, dist);
    float background = 1.0 - circle;

    float stripeCount = 17.0;
    float animatedCircleY = uv.y - iTime * 0.05;
    float animatedBgY = uv.y + iTime * 0.05;

    float circleStripeValue = fract(animatedCircleY * stripeCount) < 0.5 ? 0.0 : 1.0;
    float bgStripeValue = fract(animatedBgY * stripeCount) < 0.5 ? 0.0 : 1.0;

    float blueGradient = 1.0 - uv.y;

    vec3 circleBlueColor = vec3(0.0, 0.5, 0.8) * (blueGradient * 0.7 + 0.3);
    vec3 circleStripeColor = mix(vec3(0.0), circleBlueColor, circleStripeValue);

    vec3 bgBlueColor = vec3(0.0, 0.5, 0.8) * (blueGradient * 0.7 + 0.3);
    vec3 bgStripeColor = mix(vec3(0.05), bgBlueColor, bgStripeValue);

    vec3 finalColor = mix(bgStripeColor, circleStripeColor, circle);
    fragColor = vec4(finalColor, 1.0);
}
