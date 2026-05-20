-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Result" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "transportCO2" REAL NOT NULL,
    "foodCO2" REAL NOT NULL,
    "energyCO2" REAL NOT NULL,
    "totalCO2" REAL NOT NULL,
    "carKm" REAL NOT NULL,
    "planeKm" REAL NOT NULL,
    "meatMeals" INTEGER NOT NULL,
    "vegMeals" INTEGER NOT NULL,
    "electricity" REAL NOT NULL,
    "gas" REAL NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER,
    CONSTRAINT "Result_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
