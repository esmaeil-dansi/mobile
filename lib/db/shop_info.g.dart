// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopInfoAdapter extends TypeAdapter<ShopInfo> {
  @override
  final int typeId = 10;

  @override
  ShopInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopInfo(
      name: fields[1] as String,
      id: fields[2] as String,
      items: (fields[6] as List).cast<ShopItemTaminInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
