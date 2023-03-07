class Usuario {
  var name;
  var email;
  var senha;
  var confirmSenha;
  var telefone;
  var auth_id;
  var dataNascimento;
  var id;
  bool? check = false;
  String? photo;

  Map<String, Object?> toJson() {
    return {
      'nome': name,
      'email': email,
      'telefone': telefone,
      'id': id,
      'dataNascimento': dataNascimento,
      'photo': photo
    };
  }

  Usuario toEntity(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    name = map['nome'] ?? "";
    email = map['email'] ?? "";
    telefone = map['telefone'] ?? "";
    photo = map['photo'] ?? "";
    if (map['dataNascimento'] != null) {
      dataNascimento = (map['dataNascimento']).toDate();
    }

    return this;
  }
}
