import bcrypt from 'bcryptjs'
import prisma from '../../utils/prisma'

export default defineEventHandler(async (event) => {
    const { email, password } = await readBody(event)

    const user = await prisma.user.findUnique({ where: { email } })
    if (!user) {
        throw createError({ statusCode: 401, message: 'Неверный email или пароль' })
    }

    const valid = await bcrypt.compare(password, user.password)
    if (!valid) {
        throw createError({ statusCode: 401, message: 'Неверный email или пароль' })
    }

    return { id: user.id, email: user.email }
})