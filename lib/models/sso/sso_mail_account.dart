class SsoMailServiceAccount {
  final String googleAccount;
  final String googlePassword;
  final String o365Account;
  final String o365Password;

  SsoMailServiceAccount(
    this.googleAccount,
    this.googlePassword,
    this.o365Account,
    this.o365Password,
  );

  factory SsoMailServiceAccount.fromJson(Map<String, dynamic> json) {
    return SsoMailServiceAccount(
      json["data"]["google"]["account"],
      json["data"]["google"]["password"],
      json["data"]["o365"]["account"],
      json["data"]["o365"]["password"],
    );
  }
}
