// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..company = fields[0] as String?
      ..name = fields[1] as String
      ..address1 = fields[2] as String
      ..address2 = fields[3] as String
      ..address3 = fields[4] as String?
      ..postalCode = fields[5] as String?
      ..hdphCC = fields[6] as String
      ..hdph = fields[7] as String?
      ..officeCC = fields[8] as String?
      ..office = fields[9] as String?
      ..email = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.company)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address1)
      ..writeByte(3)
      ..write(obj.address2)
      ..writeByte(4)
      ..write(obj.address3)
      ..writeByte(5)
      ..write(obj.postalCode)
      ..writeByte(6)
      ..write(obj.hdphCC)
      ..writeByte(7)
      ..write(obj.hdph)
      ..writeByte(8)
      ..write(obj.officeCC)
      ..writeByte(9)
      ..write(obj.office)
      ..writeByte(10)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
