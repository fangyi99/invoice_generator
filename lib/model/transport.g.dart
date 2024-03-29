// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransportAdapter extends TypeAdapter<Transport> {
  @override
  final int typeId = 3;

  @override
  Transport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transport(
      type: fields[0] as String,
      amount: fields[1] as double,
      otherType: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transport obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.otherType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
