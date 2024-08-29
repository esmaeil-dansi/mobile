// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionStateAdapter extends TypeAdapter<TransactionState> {
  @override
  final int typeId = 8;

  @override
  TransactionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionState(
      code: fields[1] as String,
      closed: fields[3] as bool,
      verificationCode: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionState obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.verificationCode)
      ..writeByte(3)
      ..write(obj.closed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
