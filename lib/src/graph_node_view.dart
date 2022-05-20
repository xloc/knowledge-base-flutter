import 'package:flutter/material.dart';
import 'package:knowledge_base_flutter/src/knowledge_base_page.dart';
import 'package:knowledge_base_flutter/src/models.dart';

class GraphNodeView extends StatelessWidget {
  final void Function(String nodeID, DragUpdateDetails)? onNodeDragUpdate;
  final KnowledgeBaseView kbaseview;
  final KnowledgeBase kbase;

  const GraphNodeView({
    Key? key,
    required this.kbaseview,
    required this.kbase,
    this.onNodeDragUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: kbaseview.nodeLayout.entries.map((e) {
        return Builder(
          builder: (context) {
            double sx = 0, sy = 0;
            if (context.findRenderObject() != null) {
              final box = context.findRenderObject() as RenderBox;
              sx = box.size.width;
              sy = box.size.height;
            }
            return Positioned(
              left: e.value.dx - sx / 2,
              top: e.value.dy - sy / 2,
              child: Draggable(
                onDragUpdate: ((details) {
                  if (onNodeDragUpdate != null)
                    onNodeDragUpdate!(e.key, details);
                }),
                feedback: Container(),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(kbase.getNode(e.key)!.title)),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
