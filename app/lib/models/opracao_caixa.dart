class OperacaoCaixa {
  String? id;
  DateTime? dataCadastro;
  DateTime? dataOperacao;
  String? idResposavelCadastro;
  String? idContribuinte;
  String? nomeContribuinte;
  String? photoContribuinte;
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
      'TipoOperacao': tipoOperacao,
      'PhotoContribuinte': photoContribuinte,
      'NomeContribuinte': nomeContribuinte
    };
  }

  OperacaoCaixa toEntity(Map<String, dynamic> map) {
    id = map['Id'];
    idContribuinte = map['IdContribuinte'] ?? '';
    idResposavelCadastro = map['IdResposavelCadastro'] ?? '';
    nomeContribuinte = map['NomeContribuinte'] ?? '';
    dataCadastro = (map['DataCadastro']).toDate();
    valor = map['Valor'];
    tipoOperacao = map['TipoOperacao'];
    photoContribuinte = map['PhotoContribuinte'] ?? '';
    nomeContribuinte = map['NomeContribuinte'] ?? '';
    return this;
  }
}
