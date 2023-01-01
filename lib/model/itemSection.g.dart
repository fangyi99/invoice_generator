// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemSection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemSectionAdapter extends TypeAdapter<ItemSection> {
  @override
  final int typeId = 2;

  @override
  ItemSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemSection(
      type: fields[0] as String,
      itemList: (fields[1] as List).cast<Item>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemSection obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.itemList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
