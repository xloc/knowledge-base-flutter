import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:knowledge_base_flutter/src/graph_node_view.dart';
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
      final from = kbaseview.nodeLayout[edge.from]!;
      final to = kbaseview.nodeLayout[edge.to]!;

      var x1 = from.offset.dx;
      var y1 = from.offset.dy;
      var x2 = to.offset.dx;
      var y2 = to.offset.dy;
      if ((x1 - x2).abs() > (y1 - y2).abs()) {
        if (x1 > x2) {
          x1 -= from.size.width / 2;
          x2 += to.size.width / 2;
        } else {
          x1 += from.size.width / 2;
          x2 -= to.size.width / 2;
        }
      } else {
        if (y1 > y2) {
          y1 -= from.size.height / 2;
          y2 += to.size.height / 2;
        } else {
          y1 += from.size.height / 2;
          y2 -= to.size.height / 2;
        }
      }

      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
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
