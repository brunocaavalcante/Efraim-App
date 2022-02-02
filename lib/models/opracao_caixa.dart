class OperacaoCaixa {
  String? id;
  DateTime? dataCadastro;
  DateTime? dataOperacao;
  String? idResposavelCadastro;
  String? idContribuinte;
  String? nomeContribuinte;
  double? valor;
  int? tipoOperacao;

  Map<String, Object?> toJson() {
    return {
      'DataOperacao': dataOperacao,
      'DataCadastro': dataCadastro,
      'Id': id,
      'IdResposavelCadastro': idResposavelCadastro,
      'IdContribuinte': idContribuinte,
      'Valor': valor,
      'TipoOperacao': tipoOperacao
    };
  }

  OperacaoCaixa toEntity(Map<String, dynamic> map) {
    id = map['Id'];
    idContribuinte = map['IdContribuinte'] ?? '';
    idResposavelCadastro = map['IdResposavelCadastro'] ?? '';
    dataOperacao = (map['DataOperacao']).toDate();
    dataCadastro = (map['DataCadastro']).toDate();
    valor = map['Valor'];
    tipoOperacao = map['TipoOperacao'];
    return this;
  }
}
