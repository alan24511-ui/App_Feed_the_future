class UserModel {
  String correo;
  String password;
  String nombre;
  String apellido;
  int edad;
  String sexo;
  double peso;
  double altura;
  double imc;
  double meta;

  UserModel({
    required this.correo,
    required this.password,
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.sexo,
    required this.peso,
    required this.altura,
    required this.imc,
    required this.meta,
  });
}