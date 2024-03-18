class Matricula {
  int? status;
  String? matriculado;
  bool aceptado;
  List<dynamic>? horario;

  Matricula({
    this.status,
    this.matriculado,
    this.aceptado = false,
    this.horario,
  });

  Matricula copyWith({
    int? status,
    String? matriculado,
    bool? aceptado,
    List<dynamic>? horario,
  }) {
    return Matricula(
      status: status ?? this.status,
      matriculado: matriculado ?? this.matriculado,
      aceptado: aceptado ?? this.aceptado,
      horario: horario ?? this.horario,
    );
  }
}
