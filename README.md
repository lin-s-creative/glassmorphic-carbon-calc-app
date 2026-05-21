# Glassmorphic Carbon Calculator

Интерактивный калькулятор углеродного следа с динамическим 3D-фоном.

![Демо проекта](public/images/glow_bubble_shader.gif)

## Демо

[glassmorphic-carbon-calc-app-dtbw.vercel.app](https://glassmorphic-carbon-calc-app-dtbw.vercel.app)

## Технологии

- Nuxt 4 (SSR + API)
- Three.js + GLSL-шейдеры
- Prisma + SQLite
- Chart.js
- Postprocessing (для Bloom)
- bcryptjs для авторизации

## Установка

```bash
git clone https://github.com/lin-s-creative/glassmorphic-carbon-calc-app.git
cd glassmorphic-carbon-calc-app
npm install
npx prisma migrate dev --name init
npx prisma generate
npm run dev