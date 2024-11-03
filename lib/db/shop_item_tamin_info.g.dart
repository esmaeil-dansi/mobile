// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item_tamin_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopItemTaminInfoAdapter extends TypeAdapter<ShopItemTaminInfo> {
  @override
  final int typeId = 11;

  @override
  ShopItemTaminInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopItemTaminInfo(
      amount: fields[1] as double,
      name: fields[2] as String,
      price: fields[3] as double,
      deposit: fields[5] as double,
      description: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopItemTaminInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.deposit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopItemTaminInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
