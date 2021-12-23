import 'package:dq5monsters/monster.dart';
import 'package:dq5monsters/monster_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GridPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(monsterViewController).initState();
      return ref.read(monsterViewController).dispose;
    }, []);
    final List<Monster>? monsters = ref.watch(sortedMonsterState);
    if (monsters == null) {
      return Container(child: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('DQ5 仲間コンプチェックリスト')),
      body: Scrollbar(
        child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: CustomScrollView(slivers: <Widget>[
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final monster = monsters[index];
                      if ((monster).isChecked) {
                        return _getCheckedMonsterTile(monster);
                      } else {
                        return InkWell(
                          onTap: () => ref
                              .read(monsterViewController)
                              .checkMonster(monster.id),
                          child: _getMonsterTile(monster),
                        );
                      }
                    },
                    childCount: monsters.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: <Widget>[
                        Text('test'),
                      ],
                    )
                  ]),
                )
              ]),
            )),
      ),
    );
  }
}

Widget _getMonsterTile(Monster monster) {
  return Container(
    child: Stack(children: <Widget>[
      Image(
        image: AssetImage(monster.getImagePath()),
        height: 100,
        width: 100,
      ),
      Align(
        alignment: Alignment(0.0, 1.0),
        child: Text(monster.getDisplayName(), style: TextStyle(fontSize: 12)),
      ),
    ]),
  );
}

Widget _getCheckedMonsterTile(Monster monster) {
  return Container(
    child: Stack(children: <Widget>[
      ColorFiltered(
        colorFilter:
            const ColorFilter.mode(Colors.blueGrey, BlendMode.modulate),
        child: Image(
          image: AssetImage(monster.getImagePath()),
          height: 100,
          width: 100,
        ),
      ),
      Align(
        alignment: Alignment(0.0, 1.0),
        child: Text(monster.getDisplayName(), style: TextStyle(fontSize: 12)),
      ),
    ]),
  );
}
