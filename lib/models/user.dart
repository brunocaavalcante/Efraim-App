class UsuarioModel {
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
}
