class CompanyModel {
  final int? id;
  int? userId;

  String? name;
  String? logo;
  String? cnpj;
  String? cep;
  String? address;
  String? city;
  String? uf;
  String? email;
  String? phone;
  String? openDate;
  String? lastUpdate;
  String? jurisNature;
  String? complement;
  String? type;
  String? fantasyName;
  String? neighborhood;
  String? socialCapital;
  String? status;
  String? size;
  String? addressNumber;
  List<dynamic>? employers;

  DateTime? emailVerifiedAt;
  String? rememberToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  CompanyModel({
    this.id,
    this.userId,
    this.name,
    this.logo,
    this.cnpj,
    this.cep,
    this.address,
    this.city,
    this.uf,
    this.email,
    this.phone,
    this.openDate,
    this.lastUpdate,
    this.jurisNature,
    this.complement,
    this.type,
    this.fantasyName,
    this.neighborhood,
    this.socialCapital,
    this.status,
    this.size,
    this.addressNumber,
    this.employers,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.emailVerifiedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    final companyJson = json['company'] as Map<String, dynamic>?;

    return CompanyModel(
      id: companyJson?['id'] as int?,
      userId: companyJson?['user_id'] as int?,
      name: companyJson?['name'] as String?,
      logo: companyJson?['logo'] as String?,
      cnpj: companyJson?['cnpj'] as String?,
      cep: companyJson?['cep'] as String?,
      address: companyJson?['address'] as String?,
      city: companyJson?['city'] as String?,
      uf: companyJson?['uf'] as String?,
      email: companyJson?['email'] as String?,
      phone: companyJson?['phone'] as String?,
      openDate: companyJson?['opendate'] as String?,
      lastUpdate: companyJson?['lastupdate'] as String?,
      jurisNature: companyJson?['jurisnature'] as String?,
      complement: companyJson?['complement'] as String?,
      type: companyJson?['type'] as String?,
      fantasyName: companyJson?['fantasyname'] as String?,
      neighborhood: companyJson?['neighborhood'] as String?,
      socialCapital: companyJson?['socialcapital'] as String?,
      status: companyJson?['status'] as String?,
      size: companyJson?['size'] as String?,
      addressNumber: companyJson?['addressnumber'] as String?,
      employers: companyJson?['employers'] as List<dynamic>?,
      rememberToken: companyJson?['remember_token'] as String?,
      createdAt: companyJson?['created_at'] != null
          ? DateTime.parse(companyJson?['created_at'] as String)
          : null,
      emailVerifiedAt: companyJson?['email_verified_at'] != null
          ? DateTime.parse(companyJson?['email_verified_at'] as String)
          : null,
      updatedAt: companyJson?['updated_at'] != null
          ? DateTime.parse(companyJson?['updated_at'] as String)
          : null,
      deletedAt: companyJson?['deleted_at'] != null
          ? DateTime.parse(companyJson?['deleted_at'] as String)
          : null,
    );
  }
}
