<template>
  <div class="result-page">
    <div v-if="result" class="card glass-card">
      <div class="result-icon">
        <i class="fas fa-globe"></i>
      </div>
      <h2>Твой углеродный след</h2>
      <p class="subtitle">за неделю</p>
      <div class="breakdown">
        <div class="item">
          <span class="icon">
            <i class="fas fa-car"></i>
          </span>
          <span>Транспорт</span>
          <span class="value">{{ transportCO2.toFixed(1) }} кг</span>
        </div>
        <div class="item">
          <span class="icon">
            <i class="fas fa-utensils"></i>
          </span>
          <span>Питание</span>
          <span class="value">{{ foodCO2.toFixed(1) }} кг</span>
        </div>
        <div class="item">
          <span class="icon">
            <i class="fas fa-bolt"></i>
          </span>
          <span>Энергия</span>
          <span class="value">{{ energyCO2.toFixed(1) }} кг</span>
        </div>
      </div>
      <div class="total">
        <span class="total-number">{{ totalCO2.toFixed(1) }}</span>
        <span class="total-unit">кг CO₂ в неделю</span>
      </div>
      <div class="actions">
        <NuxtLink to="/calculator" class="btn">
          ← Пересчитать
        </NuxtLink>
        <NuxtLink to="/stats" class="btn btn-outline">
          <i class="fas fa-chart-line"></i> Статистика
        </NuxtLink>
      </div>
    </div>
    <div v-else class="card glass-card empty-state">
      <div class="empty-icon">
        <i class="fas fa-inbox"></i>
      </div>
      <h2>Нет данных</h2>
      <p>Вы ещё не прошли расчёт</p>
      <NuxtLink to="/calculator" class="btn">Пройти расчёт</NuxtLink>
    </div>
  </div>
</template>

<script setup>
const result = useState('result')

const totalCO2 = computed(() => result.value?.totalCO2 || 0)
const transportCO2 = computed(() => result.value?.transportCO2 || 0)
const foodCO2 = computed(() => result.value?.foodCO2 || 0)
const energyCO2 = computed(() => result.value?.energyCO2 || 0)
</script>

<style scoped>
.result-page {
  padding: 20px 0;
  max-width: 500px;
  margin: 0 auto;
}

.glass-card {
  text-align: center;
}

.result-icon {
  font-size: 3.5rem;
  margin-bottom: 10px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-8px); }
}

.subtitle {
  color: rgba(255, 255, 255, 0.5);
  margin-bottom: 24px;
  font-size: 0.95rem;
}

.breakdown {
  margin: 24px 0;
  text-align: left;
}

.item {
  display: flex;
  align-items: center;
  padding: 14px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  font-size: 1rem;
}

.icon {
  font-size: 1.4rem;
  margin-right: 14px;
  width: 32px;
  display: inline-flex;
  justify-content: center;
}

.value {
  margin-left: auto;
  font-weight: bold;
  color: #ffffff;
  font-size: 1.1rem;
}

.total {
  margin-top: 28px;
  padding-top: 24px;
  border-top: 1px solid rgba(255, 255, 255, 0.15);
}

.total-number {
  font-size: 3.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #a78bfa, #60a5fa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  display: block;
  line-height: 1.2;
}

.total-unit {
  color: rgba(255, 255, 255, 0.5);
  font-size: 1rem;
  margin-top: 4px;
  display: block;
}

.actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 28px;
}

.empty-state {
  padding: 50px 30px;
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 16px;
}

.empty-state h2 {
  margin-bottom: 8px;
}

.empty-state p {
  margin-bottom: 24px;
}

.btn i {
  margin-right: 6px;
}
</style>