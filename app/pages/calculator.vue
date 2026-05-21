<template>
  <div class="calculator">
    <div class="card glass-card">
      <div class="section-icon">
        <i class="fas fa-car"></i>
      </div>
      <h2>Транспорт</h2>
      <div class="field">
        <label>Км на машине в неделю</label>
        <div class="input-wrapper">
          <input v-model="carKm" type="number" min="0" placeholder="0" />
          <span class="unit">км</span>
        </div>
      </div>
      <div class="field">
        <label>Км на самолёте в неделю (в среднем)</label>
        <div class="input-wrapper">
          <input v-model="planeKm" type="number" min="0" placeholder="0" />
          <span class="unit">км</span>
        </div>
      </div>
    </div>
    <div class="card glass-card">
      <div class="section-icon">
        <i class="fas fa-utensils"></i>
      </div>
      <h2>Питание</h2>
      <div class="field">
        <label>Мясных приёмов пищи в неделю</label>
        <div class="input-wrapper">
          <input v-model="meatMeals" type="number" min="0" placeholder="0" />
          <span class="unit">раз</span>
        </div>
      </div>
      <div class="field">
        <label>Растительных приёмов пищи в неделю</label>
        <div class="input-wrapper">
          <input v-model="vegMeals" type="number" min="0" placeholder="0" />
          <span class="unit">раз</span>
        </div>
      </div>
    </div>
    <div class="card glass-card">
      <div class="section-icon">
        <i class="fas fa-bolt"></i>
      </div>
      <h2>Энергия</h2>
      <div class="field">
        <label>кВт⋅ч электричества в неделю</label>
        <div class="input-wrapper">
          <input v-model="electricity" type="number" min="0" placeholder="0" />
          <span class="unit">кВт⋅ч</span>
        </div>
      </div>
      <div class="field">
        <label>м³ газа в неделю</label>
        <div class="input-wrapper">
          <input v-model="gas" type="number" min="0" placeholder="0" />
          <span class="unit">м³</span>
        </div>
      </div>
    </div>
    <p v-if="error" class="error">{{ error }}</p>
    <div class="actions">
      <button @click="calculate" :disabled="loading" class="btn calc-btn">
        <span v-if="!loading">Рассчитать результат</span>
        <span v-else class="loading-text">
          <span class="spinner"></span>
          Считаем...
        </span>
      </button>
      <NuxtLink to="/" class="btn btn-outline">← На главную</NuxtLink>
    </div>
  </div>
</template>

<script setup>
const user = useState('user', () => null)
const { carKm, planeKm, meatMeals, vegMeals, electricity, gas } = useCarbon()

const loading = ref(false)
const error = ref(null)
const result = useState('result', () => null)

async function calculate() {
  loading.value = true
  error.value = null
  try {
    result.value = await $fetch('/api/calculate', {
      method: 'POST',
      body: {
        carKm: carKm.value,
        planeKm: planeKm.value,
        meatMeals: meatMeals.value,
        vegMeals: vegMeals.value,
        electricity: electricity.value,
        gas: gas.value,
        userId: user.value?.id || null
      }
    })
    await navigateTo('/result')
  } catch (e) {
    error.value = e.data?.message || e.message || 'Что-то пошло не так'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.calculator {
  margin: 0 auto;
  padding: 20px 0;
  max-width: 600px;
}

.glass-card {
  position: relative;
  overflow: hidden;
}

.glass-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.05), rgba(96, 165, 250, 0.05));
  pointer-events: none;
}

.section-icon {
  font-size: 2rem;
  margin-bottom: 10px;
}

.field {
  margin-bottom: 20px;
}

.field label {
  display: block;
  margin-bottom: 8px;
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.7);
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-wrapper input {
  flex: 1;
  padding-right: 50px;
}

.unit {
  position: absolute;
  right: 16px;
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.85rem;
  pointer-events: none;
}

.actions {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-top: 10px;
}

.calc-btn {
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.4), rgba(96, 165, 250, 0.4));
  border: 1px solid rgba(255, 255, 255, 0.25);
  min-width: 220px;
}

.calc-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.6), rgba(96, 165, 250, 0.6));
  border-color: rgba(255, 255, 255, 0.4);
}

.loading-text {
  display: flex;
  align-items: center;
  gap: 10px;
}

.spinner {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error {
  color: #ff6b6b;
  background: rgba(255, 107, 107, 0.1);
  padding: 12px 16px;
  border-radius: 12px;
  margin-bottom: 16px;
  border: 1px solid rgba(255, 107, 107, 0.2);
}
</style>