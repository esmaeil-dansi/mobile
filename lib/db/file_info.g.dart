// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileInfoAdapter extends TypeAdapter<FileInfo> {
  @override
  final int typeId = 5;

  @override
  FileInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileInfo(
      time: fields[0] as int,
      key: fields[1] as String,
      path: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FileInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
