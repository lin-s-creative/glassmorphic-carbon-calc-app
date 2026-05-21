<template>
  <div ref="containerRef" class="canvas"></div>
</template>

<script setup>
import gsap from 'gsap'
import * as THREE from 'three'
import { EffectComposer, RenderPass, BloomEffect, EffectPass } from 'postprocessing'
import smokeFrag from '~/shaders/smoke/smoke.frag.glsl?raw'
import smokeVert from '~/shaders/smoke/smoke.vert.glsl?raw'
import atomVert from '~/shaders/molecule/opal.vert.glsl?raw'
import atomFrag from '~/shaders/molecule/opal.frag.glsl?raw'
import bondFrag from '~/shaders/molecule/bond.frag.glsl?raw'

const emit = defineEmits(['ready'])
const containerRef = ref(null)

let scene,
    camera,
    renderer,
    moleculeGroup,
    composer,
    bgUniforms,
    raycaster
let animationId
let mouseX = 0, mouseY = 0, targetX = 0, targetY = 0
let hoveredMolecule = null
let baseOpalMaterial, baseBondMaterial

onMounted(async () => {
  await nextTick()
  if (!containerRef.value) return
  initScene()
  animate()
  window.addEventListener('mousemove', onMouseMove)
})

onUnmounted(() => {
  cancelAnimationFrame(animationId)
  composer?.dispose()
  renderer?.dispose()
  window.removeEventListener('mousemove', onMouseMove)
})

function onMouseMove(event) {
  mouseX = (event.clientX / window.innerWidth) * 2 - 1
  mouseY = (event.clientY / window.innerHeight) * 2 - 1

  if (!raycaster || !moleculeGroup) return
  const mouse = new THREE.Vector2(mouseX, -mouseY)
  raycaster.setFromCamera(mouse, camera)
  const intersects = raycaster.intersectObjects(moleculeGroup.children, true)

  let hitMolecule = null
  if (intersects.length > 0) {
    let obj = intersects[0].object
    while (obj.parent !== moleculeGroup && obj.parent !== null) obj = obj.parent
    if (obj.parent === moleculeGroup) hitMolecule = obj
  }

  if (hitMolecule !== hoveredMolecule) {
    if (hoveredMolecule) resetMoleculeHighlight(hoveredMolecule)
    hoveredMolecule = hitMolecule
    if (hoveredMolecule) highlightMolecule(hoveredMolecule)
  }
}

function createMolecule() {
  const molGroup = new THREE.Group()
  const carbonRadius = 0.6
  const oxygenRadius = 0.35
  const bondLength = 1.4
  const stickLength = bondLength - carbonRadius - oxygenRadius

  const opalMat = baseOpalMaterial.clone()
  const bondMat = baseBondMaterial.clone()

  const carbonMesh = new THREE.Mesh(new THREE.SphereGeometry(carbonRadius, 64, 64), opalMat)
  molGroup.add(carbonMesh)

  const angle = 105 * Math.PI / 180
  const bondGeo = new THREE.CylinderGeometry(0.04, 0.04, stickLength, 32)

  const addGroup = (sign) => {
    const group = new THREE.Group()
    const bond = new THREE.Mesh(bondGeo, bondMat)
    bond.position.y = carbonRadius + stickLength / 2
    group.add(bond)
    const oxygen = new THREE.Mesh(new THREE.SphereGeometry(oxygenRadius, 64, 64), opalMat)
    oxygen.position.y = bondLength
    group.add(oxygen)
    group.rotation.z = sign * angle / 2
    molGroup.add(group)
  }

  addGroup(-1)
  addGroup(1)

  molGroup.userData = {
    floatOffset: Math.random() * Math.PI * 2,
    floatSpeed: 0.5 + Math.random() * 1.5,
    opalMaterial: opalMat,
    bondMaterial: bondMat,
    defaultOpacity: 0.85,
    highlightOpacity: 1.0,
    defaultBrightness: 1.0,
    highlightBrightness: 2.5,
    defaultColor: new THREE.Color(0xa1b1c9),
    highlightColor: new THREE.Color(0xffaa66)
  }

  return molGroup
}

function initScene() {
  if (!containerRef.value) return

  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 100)
  camera.position.z = 10

  renderer = new THREE.WebGLRenderer({ alpha: false, antialias: true })
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.setClearColor(new THREE.Color('#0a0a2e'), 1)
  containerRef.value.appendChild(renderer.domElement)

  const bgGeo = new THREE.PlaneGeometry(2, 2)
  const bgMat = new THREE.ShaderMaterial({
    uniforms: {
      uTime: { value: 0 },
      uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) }
    },
    vertexShader: smokeVert,
    fragmentShader: smokeFrag,
    depthTest: false,
    depthWrite: false
  })
  const bgPlane = new THREE.Mesh(bgGeo, bgMat)
  bgPlane.renderOrder = -1
  scene.add(bgPlane)
  bgUniforms = bgMat.uniforms

  scene.add(new THREE.AmbientLight(0xffffff, 0.2))
  const dirLight = new THREE.DirectionalLight(0xffffff, 0.5)
  dirLight.position.set(5, 5, 5)
  scene.add(dirLight)

  baseOpalMaterial = new THREE.ShaderMaterial({
    vertexShader: atomVert,
    fragmentShader: atomFrag,
    uniforms: {
      uTime: { value: 0 },
      uOpacity: { value: 0.85 },
      uColorMultiply: { value: new THREE.Color(0xa1b1c9) },
      uBrightness: { value: 1.0 }
    },
    transparent: true
  })

  baseBondMaterial = new THREE.ShaderMaterial({
    vertexShader: atomVert,
    fragmentShader: bondFrag,
    uniforms: {
      uTime: { value: 0 },
      uOpacity: { value: 0.85 },
      uBrightness: { value: 1.0 }
    },
    transparent: true
  })

  moleculeGroup = new THREE.Group()
  scene.add(moleculeGroup)
  raycaster = new THREE.Raycaster()

  for (let i = 0; i < 40; i++) {
    const mol = createMolecule()
    mol.position.set(
        (Math.random() - 0.5) * 16,
        (Math.random() - 0.5) * 12,
        -4 + Math.random() * 8
    )
    mol.scale.setScalar(0.2 + Math.random() * 0.5)
    mol.rotation.set(Math.random() * Math.PI * 2, Math.random() * Math.PI * 2, 0)
    moleculeGroup.add(mol)
  }

  const renderPass = new RenderPass(scene, camera)
  const bloomEffect = new BloomEffect({
    intensity: 1.5,
    luminanceThreshold: 0.4,
    luminanceSmoothing: 0.3
  })
  const effectPass = new EffectPass(camera, bloomEffect)
  composer = new EffectComposer(renderer)
  composer.addPass(renderPass)
  composer.addPass(effectPass)

  window.addEventListener('resize', onResize)
  emit('ready')
}

function highlightMolecule(mol) {
  const { opalMaterial, bondMaterial, highlightOpacity, highlightBrightness, highlightColor } = mol.userData

  gsap.killTweensOf(opalMaterial.uniforms.uOpacity)
  gsap.killTweensOf(opalMaterial.uniforms.uBrightness)
  gsap.killTweensOf(opalMaterial.uniforms.uColorMultiply.value)
  gsap.killTweensOf(bondMaterial.uniforms.uOpacity)
  gsap.killTweensOf(bondMaterial.uniforms.uBrightness)

  gsap.to(opalMaterial.uniforms.uOpacity, { value: highlightOpacity, duration: 0.4, ease: 'power2.out' })
  gsap.to(opalMaterial.uniforms.uBrightness, { value: highlightBrightness, duration: 0.4, ease: 'power2.out' })
  gsap.to(opalMaterial.uniforms.uColorMultiply.value, {
    r: highlightColor.r,
    g: highlightColor.g,
    b: highlightColor.b,
    duration: 0.4,
    ease: 'power2.out'
  })
  gsap.to(bondMaterial.uniforms.uOpacity, { value: highlightOpacity, duration: 0.4, ease: 'power2.out' })
  gsap.to(bondMaterial.uniforms.uBrightness, { value: highlightBrightness, duration: 0.4, ease: 'power2.out' })
}

function resetMoleculeHighlight(mol) {
  const { opalMaterial, bondMaterial, defaultOpacity, defaultBrightness, defaultColor } = mol.userData

  gsap.killTweensOf(opalMaterial.uniforms.uOpacity)
  gsap.killTweensOf(opalMaterial.uniforms.uBrightness)
  gsap.killTweensOf(opalMaterial.uniforms.uColorMultiply.value)
  gsap.killTweensOf(bondMaterial.uniforms.uOpacity)
  gsap.killTweensOf(bondMaterial.uniforms.uBrightness)

  gsap.to(opalMaterial.uniforms.uOpacity, { value: defaultOpacity, duration: 0.4, ease: 'power2.out' })
  gsap.to(opalMaterial.uniforms.uBrightness, { value: defaultBrightness, duration: 0.4, ease: 'power2.out' })
  gsap.to(opalMaterial.uniforms.uColorMultiply.value, {
    r: defaultColor.r,
    g: defaultColor.g,
    b: defaultColor.b,
    duration: 0.4,
    ease: 'power2.out'
  })
  gsap.to(bondMaterial.uniforms.uOpacity, { value: defaultOpacity, duration: 0.4, ease: 'power2.out' })
  gsap.to(bondMaterial.uniforms.uBrightness, { value: defaultBrightness, duration: 0.4, ease: 'power2.out' })
}

function onResize() {
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
  composer?.setSize(window.innerWidth, window.innerHeight)
  if (bgUniforms) bgUniforms.uResolution.value.set(window.innerWidth, window.innerHeight)
}

function animate() {
  animationId = requestAnimationFrame(animate)
  const time = performance.now() * 0.001

  moleculeGroup?.children.forEach(mol => {
    const ud = mol.userData
    if (ud.opalMaterial) ud.opalMaterial.uniforms.uTime.value = time
    if (ud.bondMaterial) ud.bondMaterial.uniforms.uTime.value = time
    mol.position.y += Math.sin(time * ud.floatSpeed + ud.floatOffset) * 0.002
  })

  if (bgUniforms) bgUniforms.uTime.value = time

  if (moleculeGroup) {
    targetX = mouseY * 0.12
    targetY = mouseX * 0.12
    moleculeGroup.rotation.x += (targetX - moleculeGroup.rotation.x) * 0.05
    moleculeGroup.rotation.y += (targetY - moleculeGroup.rotation.y) * 0.05
  }

  composer.render()
}
</script>

<style scoped>
.canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
  pointer-events: none;
}
</style>