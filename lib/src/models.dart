import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

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
        to: edge['to'],
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

class NodeLayoutInfo {
  Size size = const Size(0, 0);
  Offset offset;
  NodeLayoutInfo({required this.offset, Size? size}) {
    if (size != null) this.size = size;
  }
}

class KnowledgeBaseView {
  Map<String, NodeLayoutInfo> nodeLayout;

  KnowledgeBaseView({required this.nodeLayout});
}
