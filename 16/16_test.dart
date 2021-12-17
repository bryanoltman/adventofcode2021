import 'package:test/test.dart';
import '16.dart';

main() {
  final literalPacketHexString = 'D2FE28';
  final operatorPacketHexString1 = '38006F45291200';
  final operatorPacketHexString2 = 'EE00D40C823060';

  test('converts hex strings to binary strings', () {
    expect(
      hexStringToBits(literalPacketHexString),
      '110100101111111000101000'.split(''),
    );
    expect(
      hexStringToBits(operatorPacketHexString1),
      '00111000000000000110111101000101001010010001001000000000'.split(''),
    );
  });

  test('parses literal Packet', () {
    final packet = Packet.fromBits(
      bitsArray: hexStringToBits(literalPacketHexString).toList(),
    );
    expect(packet.version, 6);
    expect(packet.typeId, 4);
    expect(packet.value, 2021);
    expect(packet.bitsLength, 21);
  });

  test('parses operator Packet with two literal subpackets', () {
    final packet = Packet.fromBits(
      bitsArray: hexStringToBits(operatorPacketHexString1).toList(),
    );
    expect(packet.version, 1);
    expect(packet.typeId, 6);
    expect(packet.subpackets, hasLength(2));

    expect(packet.subpackets[0].type, PacketType.literal);
    expect(packet.subpackets[1].type, PacketType.literal);
    expect(packet.subpackets[0].value, 10);
    expect(packet.subpackets[1].value, 20);

    expect(
      packet.bitsLength,
      'VVVTTTILLLLLLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBBBBBB'.length,
    );
  });

  test('parses operator Packet with literal and operator subpackets', () {
    final packet = Packet.fromBits(
      bitsArray: hexStringToBits(operatorPacketHexString2).toList(),
    );
    expect(packet.version, 7);
    expect(packet.typeId, 3);

    expect(packet.subpackets, hasLength(3));

    expect(packet.subpackets[0].type, PacketType.literal);
    expect(packet.subpackets[1].type, PacketType.literal);
    expect(packet.subpackets[2].type, PacketType.literal);
    expect(packet.subpackets[0].value, 1);
    expect(packet.subpackets[1].value, 2);
    expect(packet.subpackets[2].value, 3);

    expect(packet.subpacketsRecursive(), hasLength(4));

    expect(
      packet.bitsLength,
      'VVVTTTILLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBCCCCCCCCCCC'.length,
    );
  });

  test('evaluates packet', () {
    var packet = Packet.fromBits(
      bitsArray: hexStringToBits('C200B40A82').toList(),
    );
    expect(packet.evaluate(), 3);

    packet = Packet.fromBits(
      bitsArray: hexStringToBits('04005AC33890').toList(),
    );
    expect(packet.evaluate(), 54);

    packet = Packet.fromBits(
      bitsArray: hexStringToBits('CE00C43D881120').toList(),
    );
    expect(packet.evaluate(), 9);

    packet = Packet.fromBits(
      bitsArray: hexStringToBits('D8005AC2A8F0').toList(),
    );
    expect(packet.evaluate(), 1);

    packet = Packet.fromBits(
      bitsArray: hexStringToBits('F600BC2D8F').toList(),
    );
    expect(packet.evaluate(), 0);

    packet = Packet.fromBits(
      bitsArray: hexStringToBits('9C005AC2F8F0').toList(),
    );
    expect(packet.evaluate(), 0);

    packet = Packet.fromBits(
      bitsArray: hexStringToBits('9C0141080250320F1802104A08').toList(),
    );
    expect(packet.evaluate(), 1);
  });
}
