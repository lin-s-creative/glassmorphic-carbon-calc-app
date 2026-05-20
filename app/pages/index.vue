<template>
  <div class="home">
    <div class="hero-card">
      <h2>Калькулятор углеродного следа</h2>
      <p>Ответь на несколько вопросов о транспорте, питании и энергии — и получи персональный результат с рекомендациями по улучшению</p>
      <NuxtLink to="/calculator" class="btn">Начать расчёт</NuxtLink>
      <div class="features">
        <div class="feature">
          <span>Транспорт</span>
        </div>
        <div class="feature">
          <span>Питание</span>
        </div>
        <div class="feature">
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
  padding: 20px;
}

.hero-card {
  text-align: center;
  max-width: 500px;
  width: 100%;
  padding: 50px 40px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.hero-card h2 {
  font-size: 2rem;
  margin-bottom: 16px;
  background: linear-gradient(135deg, #ffffff, #a78bfa);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}

.hero-card p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1.05rem;
  margin-bottom: 32px;
  line-height: 1.7;
}

.btn {
  display: inline-block;
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
</style>