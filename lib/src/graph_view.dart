import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:knowledge_base_flutter/src/graph_node_view.dart';
import 'package:knowledge_base_flutter/src/knowledge_base_page.dart';
import 'package:knowledge_base_flutter/src/models.dart';

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
        CustomPaint(
          painter: ArrowPainter(
            kbaseview: kbaseview,
            kbase: kbase,
          ),
        )
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final KnowledgeBase kbase;
  final KnowledgeBaseView kbaseview;
  const ArrowPainter({
    required this.kbase,
    required this.kbaseview,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final nodes = kbaseview.nodeLayout.keys
        .map((nodeID) => kbase.getNode(nodeID)!)
        .toList();

    for (var edge in kbase.findRelatedEdges(nodes)) {
      final from = kbaseview.nodeLayout[edge.from]!.offset;
      final to = kbaseview.nodeLayout[edge.to]!.offset;

      path.moveTo(from.dx, from.dy);
      path.lineTo(to.dx, to.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
