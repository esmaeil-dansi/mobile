// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_statuse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestStatusAdapter extends TypeAdapter<RequestStatus> {
  @override
  final int typeId = 3;

  @override
  RequestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 2:
        return RequestStatus.Pending;
      case 1:
        return RequestStatus.Success;
      default:
        return RequestStatus.Pending;
    }
  }

  @override
  void write(BinaryWriter writer, RequestStatus obj) {
    switch (obj) {
      case RequestStatus.Pending:
        writer.writeByte(2);
        break;
      case RequestStatus.Success:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
