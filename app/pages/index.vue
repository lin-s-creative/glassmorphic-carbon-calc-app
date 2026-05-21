<template>
  <div class="home">
    <div class="hero-card glass">
      <div class="hero-icon">
        <img src="/images/earth.png" alt="Земля" />
      </div>
      <h2>Калькулятор углеродного следа</h2>
      <p>Ответь на несколько вопросов о транспорте, питании и энергии — и получи персональный результат с рекомендациями по улучшению</p>
      <NuxtLink to="/calculator" class="btn">
        <span>Начать расчёт</span>
        <span class="arrow">→</span>
      </NuxtLink>
      <div class="features">
        <div class="feature">
          <span class="feature-icon">
            <i class="fas fa-car"></i>
          </span>
          <span>Транспорт</span>
        </div>
        <div class="feature">
          <span class="feature-icon">
            <i class="fas fa-utensils"></i>
          </span>
          <span>Питание</span>
        </div>
        <div class="feature">
          <span class="feature-icon">
            <i class="fas fa-bolt"></i>
          </span>
          <span>Энергия</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 80vh;
  position: relative;
  z-index: 1;
  padding: 20px;
}

.hero-card {
  text-align: center;
  max-width: 500px;
  width: 100%;
  padding: 50px 40px;
}

.hero-icon img {
  width: 100px;
  height: auto;
  animation: float 3s ease-in-out infinite;
  filter: drop-shadow(0 0 10px rgba(167, 139, 250, 0.5));
}
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

.hero-card h2 {
  font-size: 2rem;
  margin-bottom: 16px;
  background: linear-gradient(135deg, #ffffff, #a78bfa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.hero-card p {
  font-size: 1.05rem;
  margin-bottom: 32px;
  line-height: 1.7;
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.3), rgba(96, 165, 250, 0.3));
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #ffffff;
  padding: 16px 32px;
  border-radius: 50px;
  text-decoration: none;
  font-weight: 600;
  font-size: 1.1rem;
  transition: all 0.3s;
  margin-bottom: 40px;
}

.btn:hover {
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.5), rgba(96, 165, 250, 0.5));
  border-color: rgba(255, 255, 255, 0.4);
  transform: translateY(-3px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
}

.arrow {
  transition: transform 0.3s;
  font-size: 1.2rem;
}

.btn:hover .arrow {
  transform: translateX(4px);
}

.features {
  display: flex;
  justify-content: center;
  gap: 30px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.feature {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.85rem;
}

.feature-icon {
  font-size: 1.5rem;
}
</style>
<script setup lang="ts">
</script>