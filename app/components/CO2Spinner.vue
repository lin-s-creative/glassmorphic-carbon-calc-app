<template>
  <div class="co2-spinner">
    <div class="center-atom"></div>
    <div class="bond bond-left"></div>
    <div class="atom atom-left"></div>
    <div class="bond bond-right"></div>
    <div class="atom atom-right"></div>
  </div>
</template>

<style scoped>
.co2-spinner {
  position: relative;
  width: 60px;
  height: 60px;
  animation: rotate-molecule 2s linear infinite;
}

@keyframes rotate-molecule {
  to { transform: rotate(360deg); }
}

.center-atom {
  width: 12px;
  height: 12px;
  background: rgba(167, 139, 250, 0.9);
  border-radius: 50%;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  box-shadow: 0 0 10px rgba(167, 139, 250, 0.8);
}

.bond {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 28px;
  height: 2px;
  background: rgba(255, 255, 255, 0.6);
  transform-origin: left center;
  box-shadow: 0 0 4px rgba(255, 255, 255, 0.4);
}

.bond-left { transform: translate(0, -50%) rotate(-52.5deg); }
.bond-right { transform: translate(0, -50%) rotate(52.5deg); }

.atom {
  width: 8px;
  height: 8px;
  background: rgba(96, 165, 250, 0.9);
  border-radius: 50%;
  position: absolute;
  box-shadow: 0 0 8px rgba(96, 165, 250, 0.8);
}

.atom-left {
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-52.5deg) translateX(28px);
}

.atom-right {
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(52.5deg) translateX(28px);
}
</style>