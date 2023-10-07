class Ouvrage {
  final bool error;
  final String message;
  final Map<String, dynamic> data;

  Ouvrage({required this.error, required this.message, required this.data});

  factory Ouvrage.fromJson(Map<String, dynamic> json) {
    return Ouvrage(
      error: json['error'],
      message: json['message'],
      data: json['data'],
    );
  }
}
