import 'dart:convert';

import 'package:climateinsight/models/weather_response_model.dart';
import 'package:climateinsight/secrets/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? _weather;

  WeatherModel? get weather => _weather;

  bool _isLoading = false;
  bool get isloading => _isLoading;

  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isLoading = true;
    _error = "";
    try {
      final apiUrl =
          "${ApiEndPoints().cityUrl}${city}&appid=${ApiEndPoints().apikey}${ApiEndPoints().unit}";
      print(apiUrl);

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        _weather = WeatherModel.fromJson(data);
        print(_weather!.name);
        notifyListeners();
      } else {
        _error = "failed to load data";
      }
    } catch (e) {
      _error = "failed to load data $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
