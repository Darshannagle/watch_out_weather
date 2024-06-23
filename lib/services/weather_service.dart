import 'dart:convert';
import 'dart:js_interop';

import 'package:http/http.dart' as http;
class WeatherService{
  final String APIKEY = "8fb164866511498484a91054242206";
  final String forecastBaseURL = "http://api.weatherapi.com/v1/forecast.json";
  final String searchURL = "https://api.weatherapi.com/v1/search.json";

  Future<Map<String,dynamic>> fetchCurrentWeather(String city) async{
    final url = '$forecastBaseURL?key=$APIKEY&q=$city&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      throw Exception("failed to load API");
    }

  }

  Future<Map<String,dynamic>> fetch7DayWeather(String city) async{
    final url = '$forecastBaseURL?key=$APIKEY&q=$city&days=7';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      print(json.decode(response.body));
      return json.decode(response.body);
    }
    else{
      throw Exception("failed to load forecast  API");
    }

  }
  Future<List<dynamic>?> fetchCitySuggestions(String query) async{
   query =   query.isNull? "" : query;
    final url = '$searchURL?key=$APIKEY&q=$query';
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);

    if(response.statusCode==200){
      print(response.body);
      return json.decode(response.body);

    }
    else{
      return null;
    }

  }
}