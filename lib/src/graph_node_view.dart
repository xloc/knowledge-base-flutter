import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        final nodeID = e.key;
        final layout = kbaseview.nodeLayout[e.key]!;
        return PositionedNode(
          layout: layout,
          onNodeDragUpdate: onNodeDragUpdate,
          nodeID: nodeID,
          node: kbase.getNode(nodeID)!,
        );
      }).toList(),
    );
  }
}

class PositionedNode extends StatefulWidget {
  const PositionedNode({
    Key? key,
    required this.layout,
    required this.onNodeDragUpdate,
    required this.nodeID,
    required this.node,
  }) : super(key: key);

  final NodeLayoutInfo layout;
  final void Function(String nodeID, DragUpdateDetails p1)? onNodeDragUpdate;
  final String nodeID;
  final Node node;

  @override
  State<PositionedNode> createState() => _PositionedNodeState();
}

class _PositionedNodeState extends State<PositionedNode> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.layout.offset.dx,
      top: widget.layout.offset.dy,
      child: Draggable(
        onDragUpdate: ((details) {
          if (widget.onNodeDragUpdate != null) {
            widget.onNodeDragUpdate!(widget.nodeID, details);
          }
        }),
        feedback: Container(),
        child: NodeView(
          node: widget.node,
          onChange: (size) {
            setState(() {
              widget.layout.size = size;
            });
          },
        ),
      ),
    );
  }
}

class NodeView extends StatefulWidget {
  const NodeView({Key? key, this.onChange, required this.node})
      : super(key: key);

  final void Function(Size)? onChange;
  final Node node;

  @override
  State<NodeView> createState() => _NodeViewState();
}

class _NodeViewState extends State<NodeView> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(widget.node.title),
      ),
    );
  }

  var widgetKey = GlobalKey();

  Size? oldSize;

  void postFrameCallback(timeStamp) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size!;
    if (oldSize == newSize) return;

    oldSize = newSize;
    if (widget.onChange == null) return;
    widget.onChange!(newSize);
  }
}
