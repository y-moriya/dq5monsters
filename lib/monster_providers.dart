import 'package:dq5monsters/monster.dart';
import 'package:dq5monsters/monster_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _monsterState = StateProvider<List<Monster>?>((ref) => null);
final sortedMonsterState = StateProvider<List<Monster>?>((ref) {
  final List<Monster>? monsters = ref.watch(_monsterState);

  return monsters;
});

final monsterViewController =
    Provider.autoDispose((ref) => MonsterViewController(ref.read));

class MonsterViewController {
  final Reader _read;
  MonsterViewController(this._read);

  Future<void> initState() async {
    _read(_monsterState.notifier).state =
        await _read(monsterRepository).readEntries();
  }

  void dispose() {
    _read(_monsterState)?.clear();
  }

  Future<void> checkMonster(String id) async {
    final now = DateTime.now();
    final monsters = _read(_monsterState)?.toList();
    if (monsters != null) {
      for (var m in monsters) {
        if (m.id == id) {
          m.isChecked = true;
          m.time = now.toString();
        }
      }
    }
  }
}
