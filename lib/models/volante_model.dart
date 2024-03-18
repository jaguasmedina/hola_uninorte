class Volante {
  int? status;
  int? total;
  int? pendientes;
  List<dynamic>? volantes;
  String? periodo;
  String? codigo;

  Volante({
    this.status,
    this.total,
    this.pendientes,
    this.volantes,
    this.periodo,
    this.codigo,
  });

  Volante copyWith({
    int? status,
    int? total,
    int? pendientes,
    List<dynamic>? volantes,
    String? periodo,
    String? codigo,
  }) {
    return Volante(
      status: status ?? this.status,
      total: total ?? this.total,
      pendientes: pendientes ?? this.pendientes,
      volantes: volantes ?? this.volantes,
      periodo: periodo ?? this.periodo,
      codigo: codigo ?? this.codigo,
    );
  }
}
