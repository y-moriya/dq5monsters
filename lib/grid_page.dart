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
      body: CustomScrollView(slivers: <Widget>[
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if ((monsters[index]).isChecked) {
                return Container(
                  child: Stack(children: <Widget>[
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Colors.grey, BlendMode.modulate),
                      child: Image(
                        image: AssetImage((monsters[index]).getImagePath()),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const Align(
                      alignment: Alignment(0.8, -0.8),
                      child: Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 64),
                    ),
                  ]),
                );
                // return Container(
                //   child: ColorFiltered(
                //     colorFilter:
                //         const ColorFilter.mode(Colors.grey, BlendMode.modulate),
                //     child: Image(
                //       image: AssetImage((monsters[index]).getImagePath()),
                //       fit: BoxFit.fitWidth,
                //     ),
                //   ),
                // );
              } else {
                return Container(
                  child: Stack(children: <Widget>[
                    Image(
                      image: AssetImage((monsters[index]).getImagePath()),
                      fit: BoxFit.fitWidth,
                    ),
                    Align(
                      alignment: Alignment(0.0, 1.0),
                      child: Text('スライムベホマズン', style: TextStyle(fontSize: 12)),
                    ),
                  ]),
                );
                // return Container(
                //   child: Image(
                //     image: AssetImage((monsters[index]).getImagePath()),
                //     fit: BoxFit.fitWidth,
                //   ),
                // );
              }
            },
            childCount: monsters.length,
          ),
        ),
      ]),
    );
  }
}
