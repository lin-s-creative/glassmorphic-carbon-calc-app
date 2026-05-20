<template>
  <div class="stats-page">
    <div class="cards-row">
      <div class="card glass-card" v-if="hasData">
        <div class="card-header">
          <i class="fas fa-chart-simple card-header-icon"></i>
          <h2>Мой последний расчёт</h2>
        </div>
        <div class="chart-area my-chart">
          <canvas ref="chartRef"></canvas>
        </div>
        <p class="total">{{ totalCO2 }} кг CO₂</p>
      </div>
      <div class="card glass-card" v-else>
        <div class="card-header">
          <i class="fas fa-chart-simple card-header-icon"></i>
          <h2>Мой последний расчёт</h2>
        </div>
        <div class="chart-area question-placeholder">
          <i class="fas fa-circle-question neon-question-icon"></i>
        </div>
        <p>У тебя пока нет расчётов</p>
        <NuxtLink to="/calculator" class="btn">Пройти расчёт</NuxtLink>
      </div>
      <div class="card glass-card">
        <div class="card-header">
          <i class="fas fa-globe card-header-icon"></i>
          <h2>Среднее по всем пользователям</h2>
        </div>
        <p class="count-text" v-if="globalStats.count > 0">На основе {{ globalStats.count }} расчётов</p>
        <div class="chart-area global-chart" v-if="globalStats.count > 0">
          <canvas ref="globalChartRef"></canvas>
        </div>
        <p class="total" v-if="globalStats.count > 0">Средний: {{ globalStats.avgTotal }} кг CO₂</p>
        <p class="empty-text" v-else>Пока нет данных от других пользователей</p>
      </div>
    </div>
    <div class="actions">
      <NuxtLink to="/calculator" class="btn">Калькулятор</NuxtLink>
      <NuxtLink to="/" class="btn btn-outline">На главную</NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { Chart, registerables } from 'chart.js'
Chart.register(...registerables)

const result = useState('result')
const chartRef = ref(null)
const globalChartRef = ref(null)
let chartInstance = null
let globalChartInstance = null

const hasData = computed(() => result.value !== null && result.value?.totalCO2 > 0)
const totalCO2 = computed(() => result.value?.totalCO2 || 0)

const globalStats = ref({ count: 0, avgTransport: 0, avgFood: 0, avgEnergy: 0, avgTotal: 0 })

function getNeonTransportGradient(ctx) {
  const grad = ctx.createLinearGradient(0, 0, 200, 200)
  grad.addColorStop(0, '#c084fc')
  grad.addColorStop(1, '#7e22ce')
  return grad
}

function getNeonFoodGradient(ctx) {
  const grad = ctx.createLinearGradient(0, 0, 200, 0)
  grad.addColorStop(0, '#60a5fa')
  grad.addColorStop(1, '#2563eb')
  return grad
}

function getNeonEnergyGradient(ctx) {
  const grad = ctx.createLinearGradient(0, 0, 200, 200)
  grad.addColorStop(0, '#34d399')
  grad.addColorStop(1, '#059669')
  return grad
}

function renderMyChart(data) {
  if (chartInstance) chartInstance.destroy()
  if (!chartRef.value) return
  const ctx = chartRef.value.getContext('2d')
  chartInstance = new Chart(chartRef.value, {
    type: 'doughnut',
    data: {
      labels: ['Транспорт', 'Питание', 'Энергия'],
      datasets: [{
        data: [data.transportCO2, data.foodCO2, data.energyCO2],
        backgroundColor: [getNeonTransportGradient(ctx), getNeonFoodGradient(ctx), getNeonEnergyGradient(ctx)],
        borderColor: 'rgba(255,255,255,0.3)',
        borderWidth: 2,
        hoverOffset: 10,
        cutout: '65%',
        borderRadius: 6,
        spacing: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      layout: {
        padding: 15
      },
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            color: 'rgba(255, 255, 255, 0.85)',
            font: { size: 13, weight: 'bold' },
            usePointStyle: true,
            pointStyle: 'circle',
            padding: 20
          }
        },
        tooltip: {
          backgroundColor: '#1e1e2f',
          titleColor: '#f0f0f0',
          bodyColor: '#ddd',
          borderColor: '#a78bfa',
          borderWidth: 1,
          callbacks: {
            label: (context) => `${context.label}: ${context.raw} кг CO₂`
          }
        }
      },
      animation: {
        animateRotate: true,
        duration: 1000,
        easing: 'easeOutBounce'
      }
    }
  })
  setTimeout(() => {
    if (chartRef.value) chartRef.value.style.filter = 'drop-shadow(0 0 8px rgba(167, 139, 250, 0.6))'
  }, 50)
}

function renderGlobalChart(data) {
  if (globalChartInstance) globalChartInstance.destroy()
  if (!globalChartRef.value) return
  const ctx = globalChartRef.value.getContext('2d')
  globalChartInstance = new Chart(globalChartRef.value, {
    type: 'doughnut',
    data: {
      labels: ['Транспорт', 'Питание', 'Энергия'],
      datasets: [{
        data: [data.avgTransport, data.avgFood, data.avgEnergy],
        backgroundColor: [getNeonTransportGradient(ctx), getNeonFoodGradient(ctx), getNeonEnergyGradient(ctx)],
        borderColor: 'rgba(255,255,255,0.3)',
        borderWidth: 2,
        hoverOffset: 10,
        cutout: '65%',
        borderRadius: 6,
        spacing: 2
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      layout: {
        padding: 15
      },
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            color: 'rgba(255, 255, 255, 0.85)',
            font: { size: 13, weight: 'bold' },
            usePointStyle: true,
            pointStyle: 'circle',
            padding: 20
          }
        },
        tooltip: {
          backgroundColor: '#1e1e2f',
          titleColor: '#f0f0f0',
          bodyColor: '#ddd',
          borderColor: '#a78bfa',
          borderWidth: 1,
          callbacks: {
            label: (context) => `${context.label}: ${context.raw} кг CO₂`
          }
        }
      },
      animation: {
        animateRotate: true,
        duration: 800,
        easing: 'easeOutQuad'
      }
    }
  })
  setTimeout(() => {
    if (globalChartRef.value) globalChartRef.value.style.filter = 'drop-shadow(0 0 8px rgba(167, 139, 250, 0.6))'
  }, 50)
}

onMounted(async () => {
  const data = await $fetch('/api/stats')
  globalStats.value = data
  if (data.count > 0) nextTick(() => renderGlobalChart(data))
  if (hasData.value && result.value) nextTick(() => renderMyChart(result.value))
})

watch(hasData, (newVal) => {
  if (newVal && result.value) nextTick(() => renderMyChart(result.value))
})

onUnmounted(() => {
  if (chartInstance) chartInstance.destroy()
  if (globalChartInstance) globalChartInstance.destroy()
})
</script>

<style scoped>
.stats-page {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.cards-row {
  display: flex;
  flex-direction: row;
  justify-content: center;
  gap: 2rem;
  width: 100%;
  max-width: 1200px;
}

.card {
  flex: 1 1 400px;
  max-width: 480px;
  overflow: visible;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.card-header-icon {
  font-size: 1.5rem;
  color: #a78bfa;
  filter: drop-shadow(0 0 6px rgba(167, 139, 250, 0.5));
  flex-shrink: 0;
}

.card-header h2 {
  margin: 0;
  white-space: nowrap;
}

.chart-area {
  width: 100%;
  height: 320px;
  margin: 1.5rem 0;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: filter 0.4s ease;
  filter: drop-shadow(0 0 8px rgba(167, 139, 250, 0.4));
  overflow: visible;
}

.chart-area:hover {
  filter: drop-shadow(0 0 20px rgba(167, 139, 250, 0.8));
}

@keyframes neonPulse {
  0% { filter: drop-shadow(0 0 4px rgba(167, 139, 250, 0.3)); }
  100% { filter: drop-shadow(0 0 14px rgba(167, 139, 250, 0.7)); }
}

.my-chart,
.global-chart {
  animation: neonPulse 2s infinite alternate;
}

.global-chart {
  animation-delay: 0.5s;
}

.question-placeholder {
  animation: neonPulse 2s infinite alternate;
}

.neon-question-icon {
  font-size: 13rem;
  color: #c084fc;
  transition: text-shadow 0.3s;
}

.total,
.count-text,
.empty-text {
  margin-top: 0.5rem;
}

.actions {
  display: flex;
  justify-content: center;
  gap: 1.5rem;
  margin-top: 2rem;
}

@media (max-width: 640px) {
  .cards-row {
    flex-direction: column;
  }
  .card {
    flex: 1 1 auto;
    max-width: 100%;
  }
  .chart-area {
    height: 260px;
  }
  .neon-question-icon {
    font-size: 7rem;
  }
  .card-header h2 {
    font-size: 1.2rem;
  }
  .card-header-icon {
    font-size: 1.2rem;
  }
}
</style>