class Monster {
  final String id;
  final String name;
  final String name_en;
  final String probability;
  bool isChecked;
  String time;

  Monster(this.id, this.name, this.name_en, this.probability, this.isChecked,
      this.time);

  Monster.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        name_en = json['name_en'],
        probability = json['probability'],
        isChecked = json['isChecked'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_en': name_en,
        'probability': probability,
        'isChecked': isChecked,
        'time': time,
      };

  getImagePath() {
    final path = 'resource/$id-' + name_en.toLowerCase() + '.png';
    return path;
  }
}
