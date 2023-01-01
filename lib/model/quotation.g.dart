// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuotationAdapter extends TypeAdapter<Quotation> {
  @override
  final int typeId = 0;

  @override
  Quotation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quotation(
      fileName: fields[0] as String,
      documentID: fields[1] as String,
      term: fields[2] as String,
      subjectTitle: fields[3] as String,
      itemSupply: fields[4] as String,
      date: fields[5] as DateTime,
      user: fields[6] as User,
      itemSections: (fields[7] as List).cast<ItemSection>(),
      transport: fields[8] as Transport,
      tnC: fields[9] as TnC,
    );
  }

  @override
  void write(BinaryWriter writer, Quotation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.documentID)
      ..writeByte(2)
      ..write(obj.term)
      ..writeByte(3)
      ..write(obj.subjectTitle)
      ..writeByte(4)
      ..write(obj.itemSupply)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.user)
      ..writeByte(7)
      ..write(obj.itemSections)
      ..writeByte(8)
      ..write(obj.transport)
      ..writeByte(9)
      ..write(obj.tnC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
