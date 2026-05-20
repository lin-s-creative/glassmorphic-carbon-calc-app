import prisma from '../utils/prisma'

export default defineEventHandler(async (event) => {
    if (event.method !== 'POST') {
        throw createError({ statusCode: 405, message: 'Method Not Allowed' })
    }

    const body = await readBody(event)

    const transportCO2 = body.carKm * 0.12 + body.planeKm * 0.25
    const foodCO2 = body.meatMeals * 7.0 + body.vegMeals * 0.8
    const energyCO2 = body.electricity * 0.5 + body.gas * 2.0
    const totalCO2 = transportCO2 + foodCO2 + energyCO2

    const saved = await prisma.result.create({
        data: {
            transportCO2: Math.round(transportCO2 * 10) / 10,
            foodCO2: Math.round(foodCO2 * 10) / 10,
            energyCO2: Math.round(energyCO2 * 10) / 10,
            totalCO2: Math.round(totalCO2 * 10) / 10,
            carKm: body.carKm,
            planeKm: body.planeKm,
            meatMeals: body.meatMeals,
            vegMeals: body.vegMeals,
            electricity: body.electricity,
            gas: body.gas,
            userId: body.userId || null
        }
    })

    return saved
})