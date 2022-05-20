import 'package:flutter/material.dart';
import 'package:knowledge_base_flutter/src/graph_node_view.dart';
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
