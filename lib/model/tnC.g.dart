// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tnC.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TnCAdapter extends TypeAdapter<TnC> {
  @override
  final int typeId = 5;

  @override
  TnC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TnC(
      balancePmt: fields[0] as String,
      progressPmt: fields[2] as String?,
      validityPrd: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TnC obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.balancePmt)
      ..writeByte(1)
      ..write(obj.validityPrd)
      ..writeByte(2)
      ..write(obj.progressPmt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TnCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
