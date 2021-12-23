import 'package:dq5monsters/image_size.dart';
import 'package:dq5monsters/monster.dart';
import 'package:dq5monsters/monster_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _imageSizeProvider =
    StateNotifierProvider<ImageSize, double>((ref) => ImageSize());

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

    int count = monsters.where((m) => m.isChecked).toList().length;
    String title = '現在 $count / 70 残り' + (70 - count).toString() + '体';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: CustomScrollView(slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: ref.watch(_imageSizeProvider) * 1.5,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final monster = monsters[index];
                      if ((monster).isChecked) {
                        return _getCheckedMonsterTile(
                            monster, ref.watch(_imageSizeProvider));
                      } else {
                        return InkWell(
                          onTap: () => ref
                              .read(monsterViewController)
                              .checkMonster(monster.id),
                          child: _getMonsterTile(
                              monster, ref.watch(_imageSizeProvider)),
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
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text('サイズ変更'),
                            Slider(
                              min: 25,
                              max: 150,
                              value: ref.watch(_imageSizeProvider),
                              onChanged: (value) => ref
                                  .read(_imageSizeProvider.notifier)
                                  .changState(value),
                            )
                          ],
                        ),
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

Widget _getMonsterTile(Monster monster, double size) {
  return Container(
    child: Stack(children: <Widget>[
      Image(
        image: AssetImage(monster.getImagePath()),
        height: size,
        width: size,
      ),
      Align(
        alignment: Alignment(0.0, 1.0),
        child: Text(monster.getDisplayName(), style: TextStyle(fontSize: 12)),
      ),
    ]),
  );
}

Widget _getCheckedMonsterTile(Monster monster, double size) {
  return Container(
    child: Stack(children: <Widget>[
      ColorFiltered(
        colorFilter:
            const ColorFilter.mode(Colors.blueGrey, BlendMode.modulate),
        child: Image(
          image: AssetImage(monster.getImagePath()),
          height: size,
          width: size,
        ),
      ),
      Align(
        alignment: Alignment(0.0, 1.0),
        child: Text(monster.getDisplayName(), style: TextStyle(fontSize: 12)),
      ),
    ]),
  );
}
