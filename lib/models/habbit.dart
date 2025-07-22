class Habbit {
  final int id;
  final String title;
  final String icon;
  final bool sunday;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;

  Habbit({
    required this.id,
    required this.title,
    required this.icon,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  factory Habbit.fromJson(Map<String, dynamic> json) {
    return Habbit(
      id: json['id'] ?? json['ID'],
      title: json['title'],
      icon: json['icon'].toString(),
      sunday: json['sunday'],
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'sunday': sunday,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
    };
  }
}
