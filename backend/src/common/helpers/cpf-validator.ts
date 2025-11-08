// cpf-validator.ts

/**
 * Valida um CPF.
 * Aceita entrada com ou sem máscara (ex: "123.456.789-09" ou "12345678909").
 */
export function validateCPF(input: string): boolean {
  if (!input) return false;

  // Remove tudo que não for dígito
  const cpf = input.replace(/\D/g, '');

  // Deve ter 11 dígitos
  if (cpf.length !== 11) return false;

  // Rejeita sequências com todos os dígitos iguais (ex: 00000000000, 11111111111, ...)
  if (/^(\d)\1{10}$/.test(cpf)) return false;

  const digits = cpf.split('').map((d) => parseInt(d, 10));

  // Calcula um dígito verificador (1º ou 2º) dado um conjunto de pesos
  const calcCheckDigit = (slice: number[], weightStart: number): number => {
    let sum = 0;
    for (let i = 0; i < slice.length; i++) {
      sum += slice[i] * (weightStart - i);
    }
    const remainder = sum % 11;
    return remainder < 2 ? 0 : 11 - remainder;
  };

  // Primeiro dígito verificador (usando os 9 primeiros dígitos, pesos 10..2)
  const firstCheck = calcCheckDigit(digits.slice(0, 9), 10);
  if (firstCheck !== digits[9]) return false;

  // Segundo dígito verificador (usando os 9 primeiros + primeiro dígito, pesos 11..2)
  const secondCheck = calcCheckDigit(digits.slice(0, 10), 11);
  if (secondCheck !== digits[10]) return false;

  return true;
}
