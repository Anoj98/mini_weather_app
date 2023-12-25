import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_models.dart';

class WeatherService {
  static const mainUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final respons = await http
        .get(Uri.parse('$mainUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (respons.statusCode == 200) {
      return Weather.fromJson(jsonDecode(respons.body));
    } else {
      throw Exception('Weather data loading failed');
    }
  }

  Future<String> getCurrentCity() async {
    //get permition from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert location into a list of placemark by geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
