class Person {
  String? token;
  String? user;
  String? nombre;
  List<dynamic>? nombreCompleto;
  String? email;
  String? programa;
  String? documento;
  String? codigo;
  String? pidm;
  List<dynamic>? etapas;
  List<dynamic>? puntosMapa;
  String? iniciales;

  String? timeout;
  String? isLogin;
  String? oficinas;
  String? preguntas;
  String? encuestas;

  Person({
    this.token,
    this.user,
    this.nombre,
    this.nombreCompleto,
    this.email,
    this.programa,
    this.documento,
    this.codigo,
    this.pidm,
    this.etapas,
    this.puntosMapa,
    this.iniciales,
    this.timeout,
    this.isLogin,
    this.oficinas,
    this.preguntas,
    this.encuestas,
  });

  Person copyWith({
    String? token,
    String? user,
    String? nombre,
    List<dynamic>? nombreCompleto,
    String? email,
    String? programa,
    String? documento,
    String? codigo,
    String? pidm,
    List<dynamic>? etapas,
    List<dynamic>? puntosMapa,
    String? iniciales,
    String? timeout,
    String? isLogin,
    String? oficinas,
    String? preguntas,
    String? encuestas,
  }) {
    return Person(
      token: token ?? this.token,
      user: user ?? this.user,
      nombre: nombre ?? this.nombre,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      email: email ?? this.email,
      programa: programa ?? this.programa,
      documento: documento ?? this.documento,
      codigo: codigo ?? this.codigo,
      pidm: pidm ?? this.pidm,
      etapas: etapas ?? this.etapas,
      puntosMapa: puntosMapa ?? this.puntosMapa,
      iniciales: iniciales ?? this.iniciales,
      timeout: timeout ?? this.timeout,
      isLogin: isLogin ?? this.isLogin,
      oficinas: oficinas ?? this.oficinas,
      preguntas: preguntas ?? this.preguntas,
      encuestas: encuestas ?? this.encuestas,
    );
  }
}
