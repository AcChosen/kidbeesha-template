precision mediump float;
uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;  // New uniform for mouse position


void main() {
    vec2 fragCoord = gl_FragCoord.xy;
    vec2 uv = fragCoord / iResolution.xy;
    
    // Normalize mouse position (-0.5 to 0.5)
    vec2 mouseOffset = (iMouse / iResolution - 0.5) * -0.05;

    // Apply parallax effect
    vec2 centered = uv - 0.5 + mouseOffset;
    centered.x *= iResolution.x / iResolution.y;

    float radius = 0.3;
    float dist = length(centered);
    // float circle = step(dist, radius);

    float stripeCount = 16.0;
    // float animatedCircleY = uv.y - iTime * 0.05;
    float scroll = iTime * 1.0;
    float animatedBgY = uv.y;

    // float circleStripeValue = fract(animatedCircleY * stripeCount) < 0.5 ? 0.0 : 1.0;
    float bgStripeValue = fract(animatedBgY * stripeCount) < 0.5 ? 0.0 : 1.0;

    float blueGradient = clamp(sin((uv.y+scroll) * 2.0), 0.0, 1.0) ;

    // vec3 circleBlueColor = vec3(0.0, 0.5, 0.8) * (blueGradient * 0.7 + 0.3);
    // vec3 circleStripeColor = mix(vec3(0.0), circleBlueColor, circleStripeValue);

    vec3 bgBlueColor = vec3(0.0, 0.5, 0.8);
    vec3 bgBlackColor = vec3(0.0);
    vec3 bgColor = mix(bgBlueColor * 2.0, bgBlackColor, blueGradient);
    vec3 bgStripeColor = mix(vec3(0.05), bgColor, bgStripeValue);

    vec3 finalColor = bgStripeColor;
    gl_FragColor = vec4(finalColor, 1.0);
}
