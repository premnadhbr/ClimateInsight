import 'package:climateinsight/data/image_path.dart';
import 'package:climateinsight/services/location_provider.dart';
import 'package:climateinsight/services/weather_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool clicked = false;

  @override
  void initState() {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determineLocation().then((_) {
      var city = locationProvider.currentLocationName!.locality;
      if (city != null) {
        Provider.of<WeatherServiceProvider>(context, listen: false).fetchWeatherDataByCity(city);
      }
    });
    super.initState();
  }

  TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final weatherProvider = Provider.of<WeatherServiceProvider>(context, listen: false);

    final weather = weatherProvider.weather;
    final weatherDetails = weather?.weather?.first;
    final mainWeather = weather?.main;
    final sys = weather?.sys;

    int sunriseTimestamp = sys?.sunrise ?? 0;
    int sunsetTimestamp = sys?.sunset ?? 0;

    DateTime sunriseDateTime = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 65, left: 20, right: 20),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(background[weatherProvider.weather?.weather?.first.main?.toString() ?? 'Clear'] ?? "assets/img/clear.jpg"),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            if (clicked) Positioned(top: 60, left: 20, right: 20, child: SizedBox(height: 45, child: TextFormField(controller: cityController, decoration: InputDecoration(suffixIcon: IconButton(onPressed: () => weatherProvider.fetchWeatherDataByCity(cityController.text), icon: const Icon(Icons.search, color: Colors.white, size: 25)), enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),))),
            SizedBox(
              height: 50,
              child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                var locationCity;
                if (locationProvider.currentLocationName != null) {
                  locationCity = locationProvider.currentLocationName!.locality;
                } else {
                  locationCity = "Unknown Location";
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationCity,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              "Good morning",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          clicked = !clicked;
                        });
                        print(clicked);
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 32,
                      ),
                    )
                  ],
                );
              }),
            ),
            Align(
              alignment: const Alignment(0, -0.7),
              child: Image.asset(
                imagePath[weatherProvider.weather?.weather?.first.main?.toString() ?? 'Clear'] ?? "assets/img/clear.png",
              ),
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: SizedBox(
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${weatherProvider.weather?.main?.temp?.toString() ?? '--'}\u00b0 C",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                    ),
                    Text(
                      weatherProvider.weather?.name ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      weatherProvider.weather?.weather?.first.main.toString() ?? 'Clear',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      DateFormat.jm().format(DateTime.now()),
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.75),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20)),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/temperature-high.png",
                              height: 65,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Temp Max",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  "${weatherProvider.weather?.main!.tempMax!.toStringAsFixed(0) ?? '--'}\u00b0 C",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/temperature-low.png",
                              height: 65,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Temp Min",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  "${weatherProvider.weather?.main!.tempMin!.toStringAsFixed(0) ?? '--'}\u00b0 C",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.white,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/sun (1).png",
                              height: 65,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sunrise",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  "${formattedSunrise} AM",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/moon.png",
                              height: 65,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sunset",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  "${formattedSunset} PM",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
