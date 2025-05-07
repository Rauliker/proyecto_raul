class AvailabilityEntity {
  final List<String>? monday;
  final List<String>? tuesday;
  final List<String>? wednesday;
  final List<String>? thursday;
  final List<String>? friday;
  final List<String>? saturday;
  final List<String>? sunday;

  AvailabilityEntity({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });
  List<String>? getDay(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return monday;
      case 'tuesday':
        return tuesday;
      case 'wednesday':
        return wednesday;
      case 'thursday':
        return thursday;
      case 'friday':
        return friday;
      case 'saturday':
        return saturday;
      case 'sunday':
        return sunday;
      default:
        return null;
    }
  }
}
