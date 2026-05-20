export const useCarbon = () => {
    const carKm = useState('car', () => 0)
    const planeKm = useState('plane', () => 0)
    const meatMeals = useState('meat', () => 0)
    const vegMeals = useState('veg', () => 0)
    const electricity = useState('electricity', () => 0)
    const gas = useState('gas', () => 0)

    const totalCO2 = computed(() => {
        const transportCO2 = carKm.value * 0.12 + planeKm.value * 0.25
        const foodCO2 = meatMeals.value * 7.0 + vegMeals.value * 0.8
        const energyCO2 = electricity.value * 0.5 + gas.value * 2.0
        return transportCO2 + foodCO2 + energyCO2
    })

    return { carKm, planeKm, meatMeals, vegMeals, electricity, gas, totalCO2 }
}