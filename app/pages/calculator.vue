<template>
  <div class="calculator">
    <div class="card">
      <h2>Транспорт</h2>
      <div class="field">
        <label>Км на машине в неделю</label>
        <input v-model="carKm" type="number" min="0" placeholder="0" />
      </div>
      <div class="field">
        <label>Км на самолёте в неделю</label>
        <input v-model="planeKm" type="number" min="0" placeholder="0" />
      </div>
    </div>

    <div class="card">
      <h2>Питание</h2>
      <div class="field">
        <label>Мясных приёмов пищи в неделю</label>
        <input v-model="meatMeals" type="number" min="0" placeholder="0" />
      </div>
      <div class="field">
        <label>Растительных приёмов пищи в неделю</label>
        <input v-model="vegMeals" type="number" min="0" placeholder="0" />
      </div>
    </div>

    <div class="card">
      <h2>Энергия</h2>
      <div class="field">
        <label>кВт⋅ч электричества в неделю</label>
        <input v-model="electricity" type="number" min="0" placeholder="0" />
      </div>
      <div class="field">
        <label>м³ газа в неделю</label>
        <input v-model="gas" type="number" min="0" placeholder="0" />
      </div>
    </div>

    <p v-if="error" class="error">{{ error }}</p>

    <div class="actions">
      <button @click="calculate" :disabled="loading" class="btn">
        {{ loading ? 'Считаем...' : 'Рассчитать результат' }}
      </button>
      <NuxtLink to="/" class="btn btn-outline">На главную</NuxtLink>
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
    const data = await $fetch('/api/calculate', {
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

    result.value = data
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
  padding: 20px 0;
}

.card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 30px;
  margin-bottom: 20px;
}

.card h2 {
  color: #ffffff;
  margin-bottom: 20px;
  font-size: 1.4rem;
}

.field {
  margin-bottom: 18px;
}

.field label {
  display: block;
  margin-bottom: 6px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.9rem;
}

.field input {
  width: 100%;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #ffffff;
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 1rem;
}

.field input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.4);
}

.error {
  color: #ff6b6b;
  background: rgba(255, 107, 107, 0.1);
  padding: 10px 16px;
  border-radius: 10px;
  margin-bottom: 16px;
}

.actions {
  display: flex;
  gap: 12px;
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
  transition: all 0.3s;
  cursor: pointer;
  font-size: 0.95rem;
}

.btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-outline {
  background: transparent;
}
</style>