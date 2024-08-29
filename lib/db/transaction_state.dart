import 'package:frappe_app/db/request_statuse.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'transaction_state.g.dart';

@HiveType(typeId: TRANSACTION_STATE_HIVE_ID)
class TransactionState {
  @HiveField(1)
  String code;

  @HiveField(2)
  String verificationCode;

  @HiveField(3)
  bool closed;

  TransactionState({
    required this.code,
    this.closed = false,
    required this.verificationCode,
  });
}
