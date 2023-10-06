class Ouvrage {
  final String transaction;
  final String identifiant;

  Ouvrage({
    required this.transaction,
    required this.identifiant,
  });

  factory Ouvrage.fromJson(Map<String, dynamic> json) {
    return Ouvrage(
      transaction: json['transaction'],
      identifiant: json['identifiant'],
    );
  }
}
