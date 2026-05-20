import prisma from '../utils/prisma'

export default defineEventHandler(async () => {
    const allResults = await prisma.result.findMany()

    if (allResults.length === 0) {
        return { count: 0, avgTransport: 0, avgFood: 0, avgEnergy: 0, avgTotal: 0 }
    }

    const avgTransport = allResults.reduce((sum, r) => sum + r.transportCO2, 0) / allResults.length
    const avgFood = allResults.reduce((sum, r) => sum + r.foodCO2, 0) / allResults.length
    const avgEnergy = allResults.reduce((sum, r) => sum + r.energyCO2, 0) / allResults.length
    const avgTotal = allResults.reduce((sum, r) => sum + r.totalCO2, 0) / allResults.length

    return {
        count: allResults.length,
        avgTransport: Math.round(avgTransport * 10) / 10,
        avgFood: Math.round(avgFood * 10) / 10,
        avgEnergy: Math.round(avgEnergy * 10) / 10,
        avgTotal: Math.round(avgTotal * 10) / 10
    }
})