import 'package:climateinsight/services/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  LocationService locationService = LocationService();

  Placemark? _currentLocationName;
  Placemark? get currentLocationName => _currentLocationName;

  Future<void> determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _currentPosition = null;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    print(_currentPosition);

    _currentLocationName =
        await locationService.getLocationName(_currentPosition!);
    print(_currentLocationName);
    notifyListeners();
  }
}
