import 'package:flutter/material.dart';
import 'package:knowledge_base_flutter/src/knowledge_base_page.dart';

class GraphView extends StatelessWidget {
  final KnowledgeBase kbase;
  final KnowledgeBaseView kbaseview;
  const GraphView({
    required this.kbase,
    required this.kbaseview,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [GraphNodeView(kbaseview: kbaseview, kbase: kbase), Stack()],
    );
  }
}

class GraphNodeView extends StatelessWidget {
  const GraphNodeView({
    Key? key,
    required this.kbaseview,
    required this.kbase,
  }) : super(key: key);

  final KnowledgeBaseView kbaseview;
  final KnowledgeBase kbase;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: kbaseview.nodeLayout.entries.map((e) {
        return Positioned(
          left: e.value.dx,
          top: e.value.dy,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(kbase.getNode(e.key)!.title)),
          ),
        );
      }).toList(),
    );
  }
}
