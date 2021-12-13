class Usuario {
  var name;
  var email;
  var senha;
  var confirmSenha;
  var telefone;
  var auth_id;
  var dataNascimento;

  Map<String, Object?> toJson() {
    return {
      'nome': name,
      'email': email,
      'telefone': telefone,
      'auth_id': auth_id,
      'dataNascimento': dataNascimento
    };
  }

  Usuario toEntity(Map<String, dynamic> map) {
    name = map['nome'] ?? "";
    email = map['email'] ?? "";
    telefone = map['telefone'] ?? "";
    if (map['dataNascimento'] != null) {
      dataNascimento = (map['dataNascimento']).toDate();
    }

    return this;
  }
}
