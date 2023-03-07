import 'package:app_flutter/models/opracao_caixa.dart';

class Caixa {
  String? id;
  double? saldo;
  List<OperacaoCaixa>? historico;

  Map<String, Object?> toJson() {
    return {'Id': id, 'Saldo': saldo};
  }

  Caixa toEntity(Map<String, dynamic> map) {
    id = map['Id'];
    saldo = map['Saldo'];
    return this;
  }
}
