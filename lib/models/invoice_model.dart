import 'dart:convert';

class InvoiceModel {
  int id;
  String invoiceNumber;
  String amount;
  int vendorId;
  int walletId;
  int familyId;
  String image;
  String status;
  dynamic approvedBy;
  dynamic approvedAt;
  DateTime createdAt;
  DateTime updatedAt;
  FamilyWalletModel wallet;
  FamilyModel family;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.amount,
    required this.vendorId,
    required this.walletId,
    required this.familyId,
    required this.image,
    required this.status,
    required this.approvedBy,
    required this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.wallet,
    required this.family,
  });

  factory InvoiceModel.fromRawJson(String str) =>
      InvoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    amount: json["amount"],
    vendorId: json["vendor_id"],
    walletId: json["wallet_id"],
    familyId: json["family_id"],
    image: json["image"],
    status: json["status"],
    approvedBy: json["approved_by"],
    approvedAt: json["approved_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    wallet: FamilyWalletModel.fromJson(json["wallet"]),
    family: FamilyModel.fromJson(json["family"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "amount": amount,
    "vendor_id": vendorId,
    "wallet_id": walletId,
    "family_id": familyId,
    "image": image,
    "status": status,
    "approved_by": approvedBy,
    "approved_at": approvedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "wallet": wallet.toJson(),
    "family": family.toJson(),
  };
}

class FamilyModel {
  int id;
  int institutionId;
  String name;
  String code;
  String headOfFamily;
  String phone;
  dynamic email;
  dynamic address;
  int membersCount;
  bool isActive;
  int nationalityId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  FamilyModel({
    required this.id,
    required this.institutionId,
    required this.name,
    required this.code,
    required this.headOfFamily,
    required this.phone,
    required this.email,
    required this.address,
    required this.membersCount,
    required this.isActive,
    required this.nationalityId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory FamilyModel.fromRawJson(String str) =>
      FamilyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FamilyModel.fromJson(Map<String, dynamic> json) => FamilyModel(
    id: json["id"],
    institutionId: json["institution_id"],
    name: json["name"],
    code: json["code"],
    headOfFamily: json["head_of_family"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    membersCount: json["members_count"],
    isActive: json["is_active"],
    nationalityId: json["nationality_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "institution_id": institutionId,
    "name": name,
    "code": code,
    "head_of_family": headOfFamily,
    "phone": phone,
    "email": email,
    "address": address,
    "members_count": membersCount,
    "is_active": isActive,
    "nationality_id": nationalityId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class FamilyWalletModel {
  int id;
  String uuid;
  int familyId;
  String balance;
  String notes;
  bool isActive;
  DateTime expiryDate;
  int createdBy;
  dynamic deactivatedBy;
  dynamic deactivatedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String serialNumber;
  int institutionId;

  FamilyWalletModel({
    required this.id,
    required this.uuid,
    required this.familyId,
    required this.balance,
    required this.notes,
    required this.isActive,
    required this.expiryDate,
    required this.createdBy,
    required this.deactivatedBy,
    required this.deactivatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.serialNumber,
    required this.institutionId,
  });

  factory FamilyWalletModel.fromRawJson(String str) =>
      FamilyWalletModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FamilyWalletModel.fromJson(Map<String, dynamic> json) =>
      FamilyWalletModel(
        id: json["id"],
        uuid: json["uuid"],
        familyId: json["family_id"],
        balance: json["balance"],
        notes: json["notes"],
        isActive: json["is_active"],
        expiryDate: DateTime.parse(json["expiry_date"]),
        createdBy: json["created_by"],
        deactivatedBy: json["deactivated_by"],
        deactivatedAt: json["deactivated_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        serialNumber: json["serial_number"],
        institutionId: json["institution_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "family_id": familyId,
    "balance": balance,
    "notes": notes,
    "is_active": isActive,
    "expiry_date": expiryDate.toIso8601String(),
    "created_by": createdBy,
    "deactivated_by": deactivatedBy,
    "deactivated_at": deactivatedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "serial_number": serialNumber,
    "institution_id": institutionId,
  };
}
