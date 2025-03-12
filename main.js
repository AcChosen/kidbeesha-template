
// 1. Create the scene, camera, and renderer
const scene = new THREE.Scene();
const camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

// 2. Define uniforms for time, resolution, and mouse
const uniforms = {
  iTime: { value: 0 },
  iResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
  iMouse: { value: new THREE.Vector4(0, 0, 0, 0) }
};

// 3. Vertex Shader: Pass through positions without modification
const vertexShader = `
void main() {
  gl_Position = vec4(position, 1.0);
}
`;

// 4. Load the GLSL shader from an external file
fetch("shaders/frag.glsl")
  .then(response => response.text())
  .then(fragmentShader => {
    // 5. Create a ShaderMaterial with the loaded GLSL
    const material = new THREE.ShaderMaterial({
      uniforms: uniforms,
      vertexShader: vertexShader,
      fragmentShader: fragmentShader
    });

    // 6. Create a full-screen plane and add it to the scene
    const geometry = new THREE.PlaneBufferGeometry(2, 2);
    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);

    // 7. Animation loop to update time and render the scene
    function animate(time) {
      uniforms.iTime.value = time * 0.001;
      renderer.render(scene, camera);
      requestAnimationFrame(animate);
    }
    requestAnimationFrame(animate);
  })
  .catch(error => console.error("Error loading shader:", error));

// 8. Handle window resizing
window.addEventListener('resize', () => {
  renderer.setSize(window.innerWidth, window.innerHeight);
  uniforms.iResolution.value.set(window.innerWidth, window.innerHeight);
});

// 9. Update iMouse uniform on mouse events
window.addEventListener('mousemove', (event) => {
  uniforms.iMouse.value.x = event.clientX;
  uniforms.iMouse.value.y = window.innerHeight - event.clientY;
});
window.addEventListener('mousedown', () => {
  uniforms.iMouse.value.z = 1;
});
window.addEventListener('mouseup', () => {
  uniforms.iMouse.value.z = 0;
});
