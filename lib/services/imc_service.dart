class IMCService {
  static double calcularIMC(double peso, double estatura) {
    return peso / (estatura * estatura);
  }

  static String clasificacion(double imc) {
    if (imc < 18.5) return "Bajo peso";
    if (imc < 25) return "Normal";
    if (imc < 30) return "Sobrepeso";
    return "Obesidad";
  }
}