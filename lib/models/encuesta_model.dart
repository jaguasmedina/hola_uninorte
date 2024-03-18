class Encuesta {
  Map<String, dynamic>? encuesta = {};

  Encuesta({
    this.encuesta,
  });

  Encuesta copyWith({
    Map<String, dynamic>? encuesta,
  }) {
    return Encuesta(
      encuesta: encuesta ?? this.encuesta,
    );
  }
}
