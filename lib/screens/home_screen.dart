import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:watch_out_weather/screens/forcast_screen.dart';
import 'package:watch_out_weather/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();
  String city = "London";
  Map<String, dynamic>? _currentWeather;
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final weatherData = await weatherService.fetchCurrentWeather(city);
      setState(() {
        _currentWeather = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }
  void _showCitySelectionDialog(){
    showDialog(context: context, builder: (context) => AlertDialog( title: Text("Enter city Name"),
    content: TypeAheadField(suggestionsCallback: (pattern)async{
      return await weatherService.fetchCitySuggestions(pattern) as Iterable<dynamic>;
    }, itemBuilder: (context, suggestion) {
return ListTile(
  title: Text(suggestion['name']),
);
    }, onSuggestionSelected: (suggestion) {
  setState(() {
    city = suggestion['name'];
  });
    }, )   ,
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          Navigator.pop(context);
          _fetchWeather();
        }, child: Text("Submit"))
      ],
    )
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentWeather== null? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2344),
            Color.fromARGB(255,125,32, 142),
            Colors.purple,
            Color.fromARGB(255,151, 32, 142),

          ])
        ),
        child: CircularProgressIndicator(
          color: Colors.white,
        ) ,
      ) : Container(
        padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A2344),
                    Color.fromARGB(255,125,32, 142),
                    Colors.purple,
                    Color.fromARGB(255,151, 32, 142),

                  ])
          )
      ,child:
      ListView(
        children: [
          SizedBox(height: 10,),
          InkWell(
  onTap: _showCitySelectionDialog,
            child: Text(city,
            style:TextStyle(
              fontFamily: "novaSquare",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 36
            )
            ),
          ),
    Center(
      child:
      Column(
        children: [
          Image.network('http:${_currentWeather!['current']['condition']['icon']}',height: 100,width: 100,fit: BoxFit.cover,),
          Text('${_currentWeather!['current']['temp_c'].round()}°C',style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text('${_currentWeather!['current']['condition']['text']}',style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Max: ${_currentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C',style: TextStyle(color: Colors.white,fontSize: 20,),),
          Text('Min: ${_currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C',style: TextStyle(color: Colors.white,fontSize: 20,),),

        ],) ],
      ),
    ),
          SizedBox(height: 40,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherDetail("sunrise", Icons.wb_sunny,_currentWeather!['forecast']['forecastday'][0]['astro']['sunrise']),
            _buildWeatherDetail("sunset", Icons.brightness_3,_currentWeather!['forecast']['forecastday'][0]['astro']['sunset']),

          ],),
          SizedBox(height: 40,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail("Humidity", Icons.opacity,_currentWeather!['current']['humidity']),
              _buildWeatherDetail("Wind (KPH)", Icons.wind_power,_currentWeather!['current']['wind_kph']),

            ],),
          SizedBox(height: 20,),
  Center(
    child: ElevatedButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ForecastScreen(city: city),));
    }, child: Text("Next 7 days Forcast",style: TextStyle(color: Colors.white,),),style: ElevatedButton.styleFrom(backgroundColor: Colors.black,  ),),
  )
        ],
      )
        ,),

    );  }
  Widget _buildWeatherDetail(String label, IconData icon, dynamic value){
    return ClipRect(
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),child:
        Container(
  padding: EdgeInsets.all(10),
          height: 120,
          width: 120,
decoration:  BoxDecoration( borderRadius: BorderRadius.circular(10),
  gradient: LinearGradient(begin: AlignmentDirectional.topStart, end: AlignmentDirectional.bottomEnd , colors: [Color(0xFF1A2344).withOpacity(0.5),Color(0xFF1A2344).withOpacity(0.2)
  ],),
),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,children: [
              Icon(icon,color:Colors.white,),
SizedBox(height: 8,),
          Text(label,style:  TextStyle(color: Colors.white,fontSize: 15,)),
            SizedBox(height: 8,),
            Text(value is String ? value : value.toString() ,style:  TextStyle(color: Colors.white,fontSize: 15))

            ],

          ),
        )
        ,),

     );
  }
}
