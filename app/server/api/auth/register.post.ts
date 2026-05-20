import bcrypt from 'bcryptjs'
import prisma from '../../utils/prisma'

export default defineEventHandler(async (event) => {
    const { email, password } = await readBody(event)

    const existing = await prisma.user.findUnique({ where: { email } })
    if (existing) {
        throw createError({ statusCode: 400, message: 'Пользователь уже существует' })
    }

    const hashedPassword = await bcrypt.hash(password, 10)
    const user = await prisma.user.create({
        data: {
            email,
            password: hashedPassword
        }
    })

    return { id: user.id, email: user.email }
})