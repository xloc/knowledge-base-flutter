import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:knowledge_base_flutter/src/graph_view.dart';
import 'package:knowledge_base_flutter/src/models.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({
    Key? key,
  }) : super(key: key);

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  KnowledgeBase? kb;
  var kv = KnowledgeBaseView(nodeLayout: {
    "NVPA1I": NodeLayoutInfo(offset: const Offset(100, 200)), // - Living Things
    "KR3P4M": NodeLayoutInfo(offset: const Offset(400, 100)), // - Animal
    "D2PDWS": NodeLayoutInfo(offset: const Offset(700, 100)),
    "QX3XWG": NodeLayoutInfo(offset: const Offset(700, 200)),
    "M8GGP8": NodeLayoutInfo(offset: const Offset(400, 300)),
    "8FGBF9": NodeLayoutInfo(offset: const Offset(700, 300)),
  });

  @override
  void initState() {
    super.initState();
    KnowledgeBase.load('assets/storage.yaml').then((value) {
      setState(() {
        kb = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: Svg('assets/grid.svg', size: Size.square(40)),
          repeat: ImageRepeat.repeat,
          colorFilter: ColorFilter.mode(Colors.black12, BlendMode.srcIn),
        ),
      ),
      child: Stack(
        children: [
          if (kb != null)
            GraphView(
              kbase: kb!,
              kbaseview: kv,
              onNodeDragUpdate: (nodeID, details) {
                setState(() {
                  final original = kv.nodeLayout[nodeID]!.offset;
                  kv.nodeLayout[nodeID]!.offset = Offset(
                    original.dx + details.delta.dx,
                    original.dy + details.delta.dy,
                  );
                });
              },
            ),
        ],
      ),
    );
  }
}
