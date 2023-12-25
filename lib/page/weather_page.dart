import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final messageTextController = TextEditingController();
//api key
  final _WeatherService = WeatherService('aa72d75f474aa0a999679a9098a7c42a');
  Weather? _weather;

//fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _WeatherService.getCurrentCity();

    //get weather for the city
    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch (e) {
      print(e);
    }
  }

  _fetchWeatherOnSearch(String cityName) async {
    //get weather for the city

    try {
      final weather = await _WeatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thusnderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //fetch weather
    _fetchWeather();
  }

//weather animation

  @override
  Widget build(BuildContext context) {
    String? searchedCityName;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 60.0,
            margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 12, 12, 12).withOpacity(0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0,
                )
              ],
            ),
            child: TextField(
              controller: messageTextController,
              onChanged: (value) {
                searchedCityName = value;
              },
              decoration: InputDecoration(
                hintText: 'Search City',
                hintStyle: const TextStyle(
                  color: Color(0xffdddada),
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),

                //(front) right icons in search bar
                suffixIcon: Container(
                  width: 100,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const VerticalDivider(
                          indent: 10,
                          endIndent: 10,
                          color: Color(0xffdddada),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: IconButton(
                              onPressed: () {
                                messageTextController.clear();
                                setState(() {
                                  _fetchWeatherOnSearch(searchedCityName!);
                                });
                              },
                              icon:
                                  SvgPicture.asset('assets/icons/Search.svg')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Text(
            _weather?.cityName ?? 'loading',
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w700),
          ),
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          Text(
            '${_weather?.temperature.toString()}°C' ?? 'loading',
            style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 50.0,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _fetchWeather();
              });
            },
            icon: SvgPicture.asset(
              'assets/icons/location.svg',
              width: 50.0,
              height: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
