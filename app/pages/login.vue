<template>
  <div class="auth-page">
    <div class="card glass-card">
      <div class="auth-icon">
        <i class="fas fa-user-lock"></i>
      </div>
      <h2>Вход в аккаунт</h2>
      <p class="subtitle">Войдите чтобы сохранять и отслеживать свои расчёты</p>
      <div class="field">
        <label>Email</label>
        <div class="input-wrapper">
          <span class="input-icon">
            <i class="fas fa-envelope"></i>
          </span>
          <input v-model="email" type="email" placeholder="your@email.com" />
        </div>
      </div>
      <div class="field">
        <label>Пароль</label>
        <div class="input-wrapper">
          <span class="input-icon">
            <i class="fas fa-lock"></i>
          </span>
          <input v-model="password" type="password" placeholder="Введите пароль" />
        </div>
      </div>
      <p v-if="error" class="error">{{ error }}</p>
      <button @click="login" :disabled="loading" class="btn auth-btn">
        <span v-if="!loading">Войти</span>
        <span v-else class="loading-text">
          <span class="spinner"></span>
          Входим...
        </span>
      </button>
      <p class="link">Нет аккаунта? <NuxtLink to="/register">Зарегистрироваться</NuxtLink></p>
    </div>
  </div>
</template>

<script setup>
const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref(null)

const user = useState('user', () => null)

async function login() {
  loading.value = true
  error.value = null

  try {
    const data = await $fetch('/api/auth/login', {
      method: 'POST',
      body: { email: email.value, password: password.value }
    })
    user.value = data
    await navigateTo('/calculator')
  } catch (e) {
    error.value = e.data?.message || 'Ошибка входа'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 70vh;
  padding: 20px;
}

.glass-card {
  max-width: 420px;
  width: 100%;
  text-align: center;
}

.auth-icon {
  font-size: 3rem;
  margin-bottom: 12px;
}

.subtitle {
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 28px;
  font-size: 0.95rem;
}

.field {
  margin-bottom: 20px;
  text-align: left;
}

.field label {
  display: block;
  margin-bottom: 8px;
  font-size: 0.9rem;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 14px;
  font-size: 1.1rem;
  pointer-events: none;
  z-index: 1;
  color: rgba(255, 255, 255, 0.6);
}

.input-wrapper input {
  padding-left: 42px;
}

.auth-btn {
  width: 100%;
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.4), rgba(96, 165, 250, 0.4));
  border: 1px solid rgba(255, 255, 255, 0.25);
  margin-top: 8px;
}

.auth-btn:hover:not(:disabled) {
  background: linear-gradient(135deg, rgba(167, 139, 250, 0.6), rgba(96, 165, 250, 0.6));
  border-color: rgba(255, 255, 255, 0.4);
}

.loading-text {
  display: flex;
  align-items: center;
  justify-content: center;
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

.link {
  margin-top: 20px;
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.9rem;
}

.link a {
  color: rgba(167, 139, 250, 0.9);
  text-decoration: none;
  font-weight: 500;
}

.link a:hover {
  text-decoration: underline;
}

.error {
  color: #ff6b6b;
  background: rgba(255, 107, 107, 0.1);
  padding: 10px 16px;
  border-radius: 10px;
  border: 1px solid rgba(255, 107, 107, 0.2);
  margin-bottom: 16px;
  font-size: 0.9rem;
}
</style>