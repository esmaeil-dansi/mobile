// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopInfoAdapter extends TypeAdapter<ShopInfo> {
  @override
  final int typeId = 2;

  @override
  ShopInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopInfo(
      name: fields[1] as String,
      id: fields[2] as String,
      items: (fields[3] as List).cast<String>(),
      items_prices: (fields[6] as List).cast<String>(),
      items_amount: (fields[5] as List).cast<String>(),
      descriptions: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.items_amount)
      ..writeByte(6)
      ..write(obj.items_prices)
      ..writeByte(7)
      ..write(obj.descriptions);
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
