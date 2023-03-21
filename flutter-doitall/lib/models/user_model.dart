class UserModel {
  final String? token;
  final int? id;
  final int? companyid;
  final int? status;
  final int? role;

  late String? name;
  late String? email;
  late String? phone;
  late String? cpf;
  late String? avatar;

  late String? address;
  late String? complement;
  late String? street;
  late String? neighborhood;
  late String? city;
  late String? uf;
  late String? cep;
  late String? forgotpasswordcode;
  late String? temporaryemail;
  late String? lastemail;

  late String? password;

  final String? emailVerifiedAt;
  final String? twoFactorSecret;
  final String? twoFactorRecoveryCodes;
  final DateTime? twoFactorConfirmedAt;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  UserModel({
    this.id,
    this.status,
    this.role,
    this.name,
    this.companyid,
    this.email,
    this.password,
    this.phone,
    this.cpf,
    this.avatar,
    this.token,
    this.address,
    this.neighborhood,
    this.street,
    this.complement,
    this.city,
    this.uf,
    this.cep,
    this.temporaryemail,
    this.emailVerifiedAt,
    this.twoFactorSecret,
    this.twoFactorRecoveryCodes,
    this.twoFactorConfirmedAt,
    this.uid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;

    return UserModel(
      id: userJson?['id'],
      status: userJson?['status'],
      role: userJson?['role'],
      name: userJson?['name'],
      companyid: userJson?['company_id'],
      phone: userJson?['phone'],
      cpf: userJson?['cpf'],
      avatar: userJson?['avatar'],
      address: userJson?['address'],
      cep: userJson?['cep'],
      neighborhood: userJson?['neighborhood'],
      street: userJson?['street'],
      complement: userJson?['complement'],
      city: userJson?['city'],
      uf: userJson?['uf'],
      email: userJson?['email'],
      password: userJson?['password'],
      temporaryemail: userJson?['temporaryemail'],
      emailVerifiedAt: userJson?['email_verified_at'],
      twoFactorSecret: userJson?['two_factor_secret'],
      twoFactorRecoveryCodes: userJson?['two_factor_recovery_codes'],
      twoFactorConfirmedAt: userJson?['two_factor_confirmed_at'] == null
          ? null
          : DateTime.parse(userJson!['two_factor_confirmed_at']),
      uid: userJson?['uid'],
      createdAt: userJson?['created_at'] == null
          ? null
          : DateTime.parse(userJson!['created_at']),
      updatedAt: userJson?['updated_at'] == null
          ? null
          : DateTime.parse(userJson!['updated_at']),
      deletedAt: userJson?['deleted_at'],
      token: json['token'],
    );
  }
}
