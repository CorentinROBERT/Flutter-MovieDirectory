class DataConverter {
  List<Map<String, dynamic>> listMappable(List<dynamic> list) {
    return list.map((e) => e as Map<String, dynamic>).toList();
  }
}
