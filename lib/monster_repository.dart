import 'dart:convert';
import 'dart:html';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'monster.dart';

final monsterRepository = Provider.autoDispose<MonsterRepository>(
    (ref) => MonsterRepository(ref.read));

class MonsterRepository {
  final Reader _read;
  MonsterRepository(this._read);
  final Storage _localStorage = window.localStorage;

  List<Monster> parseEntries(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Monster>((json) => Monster.fromJson(json)).toList();
  }

  bool isInitial() {
    return _localStorage['monsters'] == null;
  }

  Future<List<Monster>> readEntries() async {
    if (isInitial()) {
      return _readEntriesFromInitialFile();
    } else {
      return _readEntriesFromLocalStorage();
    }
  }

  Future<List<Monster>> _readEntriesFromInitialFile() async {
    try {
      // const jsonString =
      //     '[ { "id": "01", "name": "アンクルホーン", "name_en": "Anklehorn", "probability": "1/4", "isChecked": false, "time": "" }, { "id": "01", "name": "アンクルホーン", "name_en": "Anklehorn", "probability": "1/4", "isChecked": true, "time": "" }]';
      final jsonString = await rootBundle.loadString('resource/monsters.json');
      List<Monster> monsters = parseEntries(jsonString);
      return monsters;
    } catch (e) {
      return [];
    }
  }

  List<Monster> _readEntriesFromLocalStorage() {
    try {
      final jsonString = _localStorage['monsters'];
      List<Monster> monsters = parseEntries(jsonString!);
      return monsters;
    } catch (e) {
      return [];
    }
  }

  Future<void> writeEntries(List<Monster> monsters) async {
    List<Map> encoder = [];
    for (var monster in monsters) {
      encoder.add(monster.toJson());
    }
    _localStorage['monsters'] = json.encode(encoder);
  }
}
