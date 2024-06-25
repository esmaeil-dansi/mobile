// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertisement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdvertisementAdapter extends TypeAdapter<Advertisement> {
  @override
  final int typeId = 4;

  @override
  Advertisement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Advertisement(
      date: fields[0] as String,
      title: (fields[1] as List).cast<String>(),
      body: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Advertisement obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvertisementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
