<template>
  <div class="app">
    <div class="static-bg"></div>
    <header class="header glass">
      <h1>Калькулятор углеродного следа</h1>
      <nav>
        <NuxtLink to="/">Главная</NuxtLink>
        <NuxtLink to="/calculator">Калькулятор</NuxtLink>
        <NuxtLink to="/result">Результат</NuxtLink>
        <NuxtLink to="/stats">Статистика</NuxtLink>
        <NuxtLink to="/register">Регистрация</NuxtLink>
        <NuxtLink to="/login">Вход</NuxtLink>
      </nav>
    </header>
    <main class="main">
      <NuxtPage />
    </main>
  </div>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', system-ui, sans-serif;
  color: #ffffff;
  min-height: 100vh;
  background: #0a0a2e;
}

.static-bg {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -2;
  background: radial-gradient(ellipse at center, #1a1a4e 0%, #0a0a2e 70%);
}

.glass {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
}

.header {
  position: relative;
  z-index: 10;
  padding: 16px 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 16px;
  border-radius: 16px;
}

.header h1 {
  font-size: 1.3rem;
  font-weight: 600;
  color: #ffffff;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.3);
}

.header nav { display: flex; gap: 6px; flex-wrap: wrap; }

.header a {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  padding: 8px 14px;
  border-radius: 25px;
  transition: all 0.3s;
  font-size: 0.9rem;
  border: 1px solid transparent;
}

.header a:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  color: #ffffff;
}

.main {
  position: relative;
  z-index: 1;
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 30px;
  margin-bottom: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.card h2 { color: #ffffff; margin-bottom: 16px; font-size: 1.4rem; }
.card h3 { color: rgba(255, 255, 255, 0.9); margin-bottom: 12px; }
.card p { color: rgba(255, 255, 255, 0.7); margin-bottom: 12px; line-height: 1.6; }
.card label { color: rgba(255, 255, 255, 0.8); }

.card input {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #ffffff;
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 1rem;
  width: 100%;
  transition: all 0.3s;
}

.card input:focus {
  outline: none;
  border-color: rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.12);
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.05);
}

.card input::placeholder { color: rgba(255, 255, 255, 0.3); }

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
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}

.btn-outline { background: transparent; border: 1px solid rgba(255, 255, 255, 0.2); }
.btn:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }

.field { margin-bottom: 18px; }
.field label { display: block; margin-bottom: 6px; font-size: 0.9rem; }

.link { margin-top: 16px; text-align: center; color: rgba(255, 255, 255, 0.6); }
.link a { color: rgba(255, 255, 255, 0.9); text-decoration: underline; }

.error {
  color: #ff6b6b;
  background: rgba(255, 107, 107, 0.1);
  padding: 10px 16px;
  border-radius: 10px;
  margin-bottom: 12px;
  border: 1px solid rgba(255, 107, 107, 0.2);
}

.breakdown { margin: 20px 0; }
.item {
  display: flex;
  align-items: center;
  padding: 14px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}
.icon { font-size: 1.5rem; margin-right: 12px; }
.value { margin-left: auto; font-weight: bold; color: #ffffff; }

.total {
  text-align: center;
  font-size: 1.2rem;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.2);
  color: #ffffff;
}

.total span {
  font-size: 2.5rem;
  font-weight: bold;
  background: linear-gradient(135deg, #a78bfa, #60a5fa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  display: block;
}

hr { border: none; border-top: 1px solid rgba(255, 255, 255, 0.1); margin: 16px 0; }
</style>