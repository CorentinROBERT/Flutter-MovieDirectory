class Genre {
  int id;
  String name;

  Genre(this.id, this.name);

  Genre.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"];
}
