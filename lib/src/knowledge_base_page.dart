import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:knowledge_base_flutter/src/graph_view.dart';
import 'package:yaml/yaml.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({
    Key? key,
  }) : super(key: key);

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  KnowledgeBase? kb;

  @override
  void initState() {
    super.initState();
    KnowledgeBase.load('assets/storage.yaml').then((value) {
      setState(() {
        kb = value;
      });
    });

    // KnowledgeBaseStorage().read().then((value) {
    //   setState(() {
    //     doc = value;
    //   });
    // });
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
          Center(),
          if (kb != null)
            GraphView(
              kbase: kb!,
              kbaseview: KnowledgeBaseView(nodeLayout: {
                "NVPA1I": Offset(100, 100), // - Living Things
                "KR3P4M": Offset(100, 200), // - Animal
              }),
            ),
        ],
      ),
    );
  }
}

class Edge {
  String from, to, id, type;
  Edge(
      {required this.from,
      required this.to,
      required this.id,
      required this.type});
}

class Node {
  String id, title;
  Node({required this.id, required this.title});
}

class KnowledgeBase {
  Map<String, Node> nodes = {};
  Map<String, Edge> edges = {};

  KnowledgeBase();

  KnowledgeBase.fromYaml(Map<dynamic, dynamic> doc) {
    for (var node in doc['nodes']) {
      nodes[node['id']] = Node(id: node['id'], title: node["title"]);
    }
    for (var edge in doc['edges']) {
      edges[edge['id']] = Edge(
        id: edge['id'],
        from: edge['from'],
        to: edge['from'],
        type: edge['type'],
      );
    }
  }

  static Future<Map<dynamic, dynamic>> _readYaml(String path) async {
    final str = await rootBundle.loadString(path);
    return loadYaml(str);
  }

  static Future<KnowledgeBase> load(String path) async {
    final doc = await _readYaml(path);
    return KnowledgeBase.fromYaml(doc);
  }

  Node? getNode(String id) {
    return nodes[id];
  }

  Edge? getEdge(String id) {
    return edges[id];
  }

  List<Edge> findRelatedEdges(List<Node> nodes) {
    final nodeIDs = HashSet<String>.from(nodes.map((e) => e.id));
    final relatedEdges = edges.values
        .where(
          (edge) => nodeIDs.containsAll({edge.from, edge.to}),
        )
        .toList();
    return relatedEdges;
  }
}

class KnowledgeBaseView {
  Map<String, Offset> nodeLayout;

  KnowledgeBaseView({required this.nodeLayout});
}
