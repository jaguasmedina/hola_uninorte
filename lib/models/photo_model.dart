class Photo {
  String? url;
  String? type;
  String? name;

  Photo({this.url, this.type, this.name});

  Photo copyWith({
    String? photo,
    String? type,
    String? name,
  }) {
    return Photo(
      url: photo ?? url,
      type: type ?? this.type,
      name: name ?? this.name,
    );
  }
}
