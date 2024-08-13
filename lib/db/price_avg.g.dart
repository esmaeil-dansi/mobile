// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_avg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceAvgAdapter extends TypeAdapter<PriceAvg> {
  @override
  final int typeId = 6;

  @override
  PriceAvg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceAvg(
      shotor: fields[0] as int,
      go: fields[2] as int,
      gosfand: fields[3] as int,
      gov: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PriceAvg obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.shotor)
      ..writeByte(1)
      ..write(obj.gov)
      ..writeByte(2)
      ..write(obj.go)
      ..writeByte(3)
      ..write(obj.gosfand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceAvgAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
