import 'package:flutter/material.dart';
import 'package:knowledge_base_flutter/src/knowledge_base_page.dart';

class GraphView extends StatelessWidget {
  final KnowledgeBase kbase;
  final KnowledgeBaseView kbaseview;
  final void Function(String nodeID, DragUpdateDetails)? onNodeDragUpdate;

  const GraphView({
    required this.kbase,
    required this.kbaseview,
    this.onNodeDragUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GraphNodeView(
          kbaseview: kbaseview,
          kbase: kbase,
          onNodeDragUpdate: onNodeDragUpdate,
        ),
        Stack()
      ],
    );
  }
}

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
        return Positioned(
          left: e.value.dx,
          top: e.value.dy,
          child: Draggable(
            onDragUpdate: ((details) {
              if (onNodeDragUpdate != null) onNodeDragUpdate!(e.key, details);
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
      }).toList(),
    );
  }
}
