import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

enum PacketType { literal, operator }

enum OperationType {
  sum,
  product,
  minimum,
  maximum,
  value,
  greaterThan,
  lessThan,
  equalTo,
}

class Packet {
  late int version;
  late int typeId;
  late int value;
  late List<Packet> subpackets;
  late int bitsLength;

  PacketType get type => typeId == 4 ? PacketType.literal : PacketType.operator;

  OperationType get operationType => OperationType.values[typeId];

  Packet.fromBits({required List<String> bitsArray}) {
    final versionBits = bitsArray.slice(0, 3);
    version = int.parse(versionBits.join(), radix: 2);

    final idBits = bitsArray.slice(3, 6);
    typeId = int.parse(idBits.join(), radix: 2);

    int sliceIndex = 6;

    subpackets = [];
    if (typeId == 4) {
      // Literal packet
      StringBuffer stringBuffer = StringBuffer();
      bool shouldContinue = true;
      while (shouldContinue) {
        shouldContinue = bitsArray[sliceIndex] == '1';
        final dataBits = bitsArray.slice(sliceIndex + 1, sliceIndex + 5);
        stringBuffer.writeAll(dataBits);
        sliceIndex += 5;
      }

      value = int.parse(stringBuffer.toString(), radix: 2);
      bitsLength = sliceIndex;
    } else {
      // Operator packet
      final lengthTypeBit = bitsArray[sliceIndex];
      sliceIndex++;
      if (lengthTypeBit == '0') {
        // The length of the length number. This is tedious.
        final packetLengthLength = 15;
        final packetLengthLengthbits = bitsArray.slice(
          sliceIndex,
          sliceIndex + packetLengthLength,
        );
        final subPacketsLength =
            int.parse(packetLengthLengthbits.join(), radix: 2);
        sliceIndex += packetLengthLength;

        bitsLength = sliceIndex + subPacketsLength;
        while (sliceIndex < bitsLength) {
          final subpacketBits = bitsArray.slice(sliceIndex).toList();
          final subpacket = Packet.fromBits(
            bitsArray: subpacketBits,
          );
          subpackets.add(subpacket);
          sliceIndex += subpacket.bitsLength;
        }
      } else {
        final packetLengthLength = 11;
        final packetLengthLengthbits = bitsArray.slice(
          sliceIndex,
          sliceIndex + packetLengthLength,
        );
        final subPacketsCount =
            int.parse(packetLengthLengthbits.join(), radix: 2);
        sliceIndex += packetLengthLength;
        for (int i = 0; i < subPacketsCount; i++) {
          final subpacketBits = bitsArray.slice(sliceIndex).toList();
          final subpacket = Packet.fromBits(
            bitsArray: subpacketBits,
          );
          subpackets.add(subpacket);
          sliceIndex += subpacket.bitsLength;
        }

        bitsLength = sliceIndex;
      }
    }
  }

  Iterable<Packet> subpacketsRecursive() {
    return [this] +
        subpackets
            .map((e) => e.subpacketsRecursive())
            .expand((e) => e)
            .toList();
  }

  int evaluate() {
    switch (operationType) {
      case OperationType.sum:
        return subpackets.map((e) => e.evaluate()).sum;
      case OperationType.product:
        return subpackets.map((e) => e.evaluate()).reduce((acc, e) => acc * e);
      case OperationType.minimum:
        return subpackets
            .map((e) => e.evaluate())
            .reduce((acc, e) => min(acc, e));
      case OperationType.maximum:
        return subpackets
            .map((e) => e.evaluate())
            .reduce((acc, e) => max(acc, e));
      case OperationType.value:
        return value;
      case OperationType.greaterThan:
        return subpackets[0].evaluate() > subpackets[1].evaluate() ? 1 : 0;
      case OperationType.lessThan:
        return subpackets[0].evaluate() < subpackets[1].evaluate() ? 1 : 0;
      case OperationType.equalTo:
        return subpackets[0].evaluate() == subpackets[1].evaluate() ? 1 : 0;
    }
  }
}

Iterable<String> hexStringToBits(String string) {
  final hexNums = string.split('').map((e) => int.parse(e, radix: 16));
  final binaryStrings = hexNums.map((e) => e.toRadixString(2).padLeft(4, '0'));
  return binaryStrings.map((e) => e.split('')).expand((e) => e);
}

main() {
  final inputString = File('input.txt').readAsLinesSync()[0];
  final packet = Packet.fromBits(
    bitsArray: hexStringToBits(inputString).toList(),
  );
  final allPackets = packet.subpacketsRecursive();
  final versionSum = allPackets.map((e) => e.version).sum;
  print('versionSum is $versionSum');

  print('evaluated packet is ${packet.evaluate()}');
}
