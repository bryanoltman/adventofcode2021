import 'package:test/test.dart';
import '12.dart';

main() {
  final input = '''
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end''';
  final largerInput = '''
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
  ''';

  late Set<Node> nodes;

  setUp(() {
    nodes = readNodes(input);
  });

  test('reads input', () {
    final startNode = nodes.firstWhere((e) => e.value == 'start');
    expect(startNode.connectingNodes, hasLength(2));
    expect(startNode.connectingNodes, {Node('A'), Node('b')});

    final ANode = nodes.firstWhere((e) => e.value == 'A');
    expect(ANode.connectingNodes, hasLength(4));
    expect(ANode.connectingNodes, {
      Node('start'),
      Node('end'),
      Node('c'),
      Node('b'),
    });
  });

  test('finds all valid paths from start to finish', () {
    final paths = findPathsPart1(nodes);
    expect(paths, hasLength(10));
  });

  test('finds paths in larger input', () {
    nodes = readNodes(largerInput);
    final paths = findPathsPart1(nodes);
    expect(paths, hasLength(19));
  });

  test('finds all valid paths from start to finish, part 2', () {
    final paths = findPathsPart2(nodes);
    expect(paths, hasLength(36));
  });

  test('finds all valid paths from start to finish in larger input, part 2',
      () {
    nodes = readNodes(largerInput);
    final paths = findPathsPart2(nodes);
    expect(paths, hasLength(103));
  });
}
