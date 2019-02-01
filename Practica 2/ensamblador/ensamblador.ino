#include <math.h>

void setup()
{
  Serial.begin(9600);
  
  // put your setup code here, to run once:

  Serial.println("Determinante");
  Serial.println(getDeterminant(10, 20, 30));
  Serial.println(getDeterminantAssembly(10, 20, 30));
  Serial.println("Promedio");
  int a[] = {1, 2, 3, 4};
  Serial.println(getAverage(a, 4));
  Serial.println(getAverageAssembly(a, 4));
}

/**
 * Gets determinant of a cuadratic equation.
 */
int getDeterminant(int a, int b, int c)
{
  return pow(b, 2) - 4 * a * c;
}

int getDeterminantAssembly(int a, int b, int c)
{
  int res = 0;
  
  asm volatile(
    "MOV r16, %1  \n\t" // a
    "MOV r17, %2  \n\t" // b
    "MOV r18, %3  \n\t" // c
    "LDI r19, 0x04  \n\t" // 4
    "MULS r17, r17  \n\t" // b²
    "MOV r20, r0  \n\t" // Saves b² LSB
    "MOV r21, r1  \n\t" // Saves b² MSB
    "LSL r16 \n\t"  // 2 * a
    "LSL r18 \n\t"  // 2 * c
    "MULS r16, r18  \n\t" // 2 * a * 2 * c
    "SUB r20, r0 \n\t" // Resta de LSB
    "SBC r21, r1 \n\t" // Resta de MSB
    "MOVW %0, r20  \n\t"
    : "=r" (res)
    : "r" (a), "r" (b), "r" (c)
  );

  Serial.println(res);

  return res;
}

/**
 * Gets the average.
 */
int getAverage(int n[], int size)
{
  int sum = 0;
  for (int i = 0; i < size; i++)
    sum += n[i];

  return sum / size;
}

int getAverageAssembly(int n[], int size)
{
  int res = 0;
  asm volatile(
    "MOV r18, 0x00 \n\t" // Sum
    "MOV r16, %1  \n\t" // size
    "MOV r17, 0x00 \n\t" // i
    "FOR: \n\t"
    "ADD r18, (%2) \n\t"
    "ADD %2, 0x2 \n\t"
    "INC r17 \n\t" // Increments
    "CPSE r16, r17 \n\t" // Compares
    "JMP FOR \n\t" // Returns

    "MOV r17, 0x00 \n\t" // i
    "FOR2: \n\t"
    "SUB r18, r16 \n\t" // Substract
    "BRMI 0x2 \n\t" // Compares
    "INC r17 \n\t" // i++
    "JMP FOR2 \n\t" // Returns
    "MOV %0, r17 \n\t"
    : "=r" (res)
    : "r" (size), "r" (n)
  );
  
  return res;
}

void loop()
{
  // put your main code here, to run repeatedly:
}
