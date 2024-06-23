import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  const ForecastScreen({required this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService weatherService = WeatherService();
  List<dynamic>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    try {
      final forecastData = await weatherService.fetch7DayWeather(widget.city);
      setState(() {
        _forecast = forecastData['forecast']['forecastday'];
        print('forecast =================>');
        print(_forecast);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _forecast == null
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        )
            : Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A2344),
                Color.fromARGB(255, 125, 32, 142),
                Colors.purple,
                Color.fromARGB(255, 151, 32, 142),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "7 Days Forecast",
                        style: TextStyle(
                          fontFamily: "novaSquare",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: _forecast!.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final day = _forecast![index];
                    String iconUrl =
                        'http:${day['day']['condition']['icon']}';
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                                colors: [
                                  Color(0xFF1A2344).withOpacity(0.5),
                                  Color(0xFF1A2344).withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: ListTile(
                              leading: iconUrl.isNotEmpty
                                  ? Image.network(iconUrl)
                                  : Placeholder(), // or default image widget
                              title: Text(
                                '${day['date']} - ${day['day']['avgtemp_c']} °C',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Max ${day['day']['maxtemp_c']}°C',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Min ${day['day']['mintemp_c']}°C',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                day['day']['condition']['text'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
