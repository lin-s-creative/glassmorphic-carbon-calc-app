<template>
  <div class="result-page">
    <div class="card">
      <h2>Твой углеродный след</h2>
      <p>за неделю</p>

      <div class="breakdown">
        <div class="item">
          <span>Транспорт</span>
          <span class="value">{{ transportCO2.toFixed(1) }} кг</span>
        </div>
        <div class="item">
          <span>Питание</span>
          <span class="value">{{ foodCO2.toFixed(1) }} кг</span>
        </div>
        <div class="item">
          <span>Энергия</span>
          <span class="value">{{ energyCO2.toFixed(1) }} кг</span>
        </div>
      </div>

      <div class="total">
        <span class="total-number">{{ totalCO2.toFixed(1) }}</span>
        кг CO₂ в неделю
      </div>

      <div class="actions">
        <NuxtLink to="/calculator" class="btn">Пересчитать</NuxtLink>
        <NuxtLink to="/" class="btn btn-outline">На главную</NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
const { totalCO2, carKm, planeKm, meatMeals, vegMeals, electricity, gas } = useCarbon()

const transportCO2 = computed(() => carKm.value * 0.12 + planeKm.value * 0.25)
const foodCO2 = computed(() => meatMeals.value * 7.0 + vegMeals.value * 0.8)
const energyCO2 = computed(() => electricity.value * 0.5 + gas.value * 2.0)
</script>

<style scoped>
.result-page {
  padding: 20px 0;
}

.card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 30px;
  text-align: center;
}

.card h2 {
  color: #ffffff;
  margin-bottom: 8px;
}

.card p {
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 24px;
}

.breakdown {
  margin: 24px 0;
}

.item {
  display: flex;
  justify-content: space-between;
  padding: 14px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  color: rgba(255, 255, 255, 0.8);
}

.value {
  font-weight: bold;
  color: #ffffff;
}

.total {
  margin-top: 28px;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.15);
  color: rgba(255, 255, 255, 0.6);
}

.total-number {
  font-size: 3.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #a78bfa, #60a5fa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  display: block;
}

.actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 28px;
}

.btn {
  display: inline-block;
  background: rgba(255, 255, 255, 0.1);
  color: #ffffff;
  padding: 14px 28px;
  border-radius: 30px;
  text-decoration: none;
  font-weight: 600;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.btn-outline {
  background: transparent;
}
</style>