class FAQ {
  List<dynamic>? preguntas;

  FAQ({
    this.preguntas,
  });

  FAQ copyWith({
    List<dynamic>? preguntas,
  }) {
    return FAQ(
      preguntas: preguntas ?? this.preguntas,
    );
  }
}
