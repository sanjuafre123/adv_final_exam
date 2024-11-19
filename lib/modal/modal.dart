class ShoppingModal {
  String name;
  int qut;
  String cate;
  bool done;

  ShoppingModal({
    required this.name,
    required this.qut,
    required this.cate,
    required this.done,
  });

  factory ShoppingModal.fromMap(Map<String, dynamic> map) {
    return ShoppingModal(
      name: map['name'],
      qut: map['qut'],
      cate: map['cate'],
      done: map['done'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qut': qut,
      'cate': cate,
      'done': done ? 1 : 0,
    };
  }
}
