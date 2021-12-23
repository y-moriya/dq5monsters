import 'package:dq5monsters/image_size.dart';
import 'package:dq5monsters/monster.dart';
import 'package:dq5monsters/monster_providers.dart';
import 'package:dq5monsters/show_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _imageSizeProvider =
    StateNotifierProvider<ImageSize, double>((ref) => ImageSize());

final _showNameProvider =
    StateNotifierProvider<ShowName, bool>((ref) => ShowName());

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
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final monster = monsters[index];
                      if ((monster).isChecked) {
                        return InkWell(
                          onTap: () => ref
                              .read(monsterViewController)
                              .unCheckMonster(monster.id),
                          child: _getCheckedMonsterTile(
                              monster,
                              ref.watch(_imageSizeProvider),
                              ref.watch(_showNameProvider)),
                        );
                      } else {
                        return InkWell(
                          onTap: () => ref
                              .read(monsterViewController)
                              .checkMonster(monster.id),
                          child: _getMonsterTile(
                              monster,
                              ref.watch(_imageSizeProvider),
                              ref.watch(_showNameProvider)),
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
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text('名前表示'),
                            Checkbox(
                                value: ref.watch(_showNameProvider),
                                onChanged: (value) => ref
                                    .read(_showNameProvider.notifier)
                                    .changState(value))
                          ],
                        ),
                        const SizedBox(
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
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: MaterialButton(
                              onPressed: () => _showAlertDialog(context, ref),
                              child: const Text('リセット'),
                              color: Colors.red,
                              textColor: Colors.white),
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

void _showAlertDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) {
      final String message = "データを全て消去してリセットします\n\n"
          "よろしいですか？";
      return AlertDialog(
        title: const Text('リセット'),
        scrollable: true,
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              ref.read(monsterViewController).reset();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _getMonsterTile(Monster monster, double size, bool showName) {
  return Container(
    child: Stack(children: <Widget>[
      Image(
        image: AssetImage(monster.getImagePath()),
        height: size,
        width: size,
      ),
      showName
          ? Align(
              alignment: Alignment(0.0, 1.0),
              child: Text(monster.getDisplayName(),
                  style: TextStyle(fontSize: 12)),
            )
          : Container(),
    ]),
  );
}

Widget _getCheckedMonsterTile(Monster monster, double size, bool showName) {
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
      Image(
        image: AssetImage('resource/sumi.png'),
        height: size,
        width: size,
      ),
      showName
          ? Align(
              alignment: Alignment(0.0, 1.0),
              child: Text(monster.getDisplayName(),
                  style: TextStyle(fontSize: 12)),
            )
          : Container(),
    ]),
  );
}
