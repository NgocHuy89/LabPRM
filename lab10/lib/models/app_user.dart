class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String provider; // "api" or "google"

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.provider,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'provider': provider,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        avatarUrl: json['avatarUrl'],
        provider: json['provider'] ?? 'api',
      );
}
