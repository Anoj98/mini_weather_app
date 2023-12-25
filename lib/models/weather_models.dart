class Weather {
  final String cityName;
  final int temperature;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.mainCondition,
      required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toInt(),
        mainCondition: json['weather'][0]['main']);
  }
}
