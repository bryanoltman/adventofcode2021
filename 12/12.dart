class Node {
  final String value;
  Set<Node> connectingNodes = {};

  Node(this.value);

  bool get isBigCave => value.toUpperCase() == value;

  bool get isSmallCave => value.toLowerCase() == value;

  @override
  String toString() => value;

  @override
  operator ==(Object other) => other is Node && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

Set<Node> readNodes(String input) {
  final lines = input.split('\n').map((e) => e.trim()).where((e) => !e.isEmpty);
  final nodes = lines
      .map((e) => e.split('-'))
      .expand((e) => e)
      .map((e) => Node(e))
      .toSet();
  for (final line in lines) {
    final parts = line.split('-');
    final firstNode = nodes.firstWhere((e) => e.value == parts[0]);
    final secondNode = nodes.firstWhere((e) => e.value == parts[1]);
    firstNode.connectingNodes.add(secondNode);
    secondNode.connectingNodes.add(firstNode);
  }
  return nodes;
}

List<List<Node>> findPathsPart1(Set<Node> nodes) {
  final startNode = nodes.firstWhere((e) => e.value == 'start');
  var openPaths = [
    [startNode],
  ];
  var closedPaths = <List<Node>>[];

  while (openPaths.isNotEmpty) {
    final path = openPaths.removeLast();
    final lastNode = path.last;
    if (lastNode.value == 'end') {
      closedPaths.add(path);
      continue;
    }
    final nextNodes = lastNode.connectingNodes
        .where((e) => e.value != 'start')
        .where((e) =>
            e.value == 'end' ||
            e.isBigCave ||
            (e.isSmallCave && !path.contains(e)));
    openPaths.addAll(nextNodes.map((e) => path + [e]));
  }

  return closedPaths;
}

List<List<Node>> findPathsPart2(Set<Node> nodes) {
  final startNode = nodes.firstWhere((e) => e.value == 'start');
  var openPaths = [
    [startNode],
  ];
  var closedPaths = <List<Node>>[];

  while (openPaths.isNotEmpty) {
    final path = openPaths.removeLast();
    final lastNode = path.last;
    if (lastNode.value == 'end') {
      closedPaths.add(path);
      continue;
    }
    final smallCavesInPath = path.where((e) => e.isSmallCave);
    final doubleSmallCave = smallCavesInPath.where(
        (smallCave) => path.where((cave) => cave == smallCave).length > 1);
    final nextNodes = lastNode.connectingNodes
        .where((e) => e.value != 'start')
        .where(
          (e) =>
              e.value == 'end' ||
              e.isBigCave ||
              (e.isSmallCave && (!path.contains(e) || doubleSmallCave.isEmpty)),
        );
    openPaths.addAll(nextNodes.map((e) => path + [e]));
  }

  return closedPaths;
}

main() {
  final input = '''
    ln-nr
    ln-wy
    fl-XI
    qc-start
    qq-wy
    qc-ln
    ZD-nr
    qc-YN
    XI-wy
    ln-qq
    ln-XI
    YN-start
    qq-XI
    nr-XI
    start-qq
    qq-qc
    end-XI
    qq-YN
    ln-YN
    end-wy
    qc-nr
    end-nr
  ''';
  final nodes = readNodes(input);
  final pathsPart1 = findPathsPart1(nodes);
  print('found ${pathsPart1.length} paths in part 1');

  final pathsPart2 = findPathsPart2(nodes);
  print('found ${pathsPart2.length} paths in part 2');
}
