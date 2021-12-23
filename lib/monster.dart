class Monster {
  final String id;
  final String name;
  final String name_en;
  final String probability;
  final int rank;
  bool isChecked;
  String time;

  Monster(this.id, this.name, this.name_en, this.probability, this.rank,
      this.isChecked, this.time);

  Monster.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        name_en = json['name_en'],
        probability = json['probability'],
        rank = json['rank'],
        isChecked = json['isChecked'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_en': name_en,
        'probability': probability,
        'rank': rank,
        'isChecked': isChecked,
        'time': time,
      };

  String getImagePath() {
    final path = 'resource/$id-' + name_en.toLowerCase() + '.png';
    return path;
  }

  String getDisplayName() {
    if (rank == 8) {
      return name;
    } else {
      return name + '($probability)';
    }
  }
}
