import 'dart:convert';
import 'package:http/http.dart';
import 'package:weather_warner/services/weather_model.dart';

class WeatherService {
  String accuKey = 'CL3aLWg6DShqqvg6jqfEoARCtKr1d6gz';
  String accuKey2 = 'U9VyAiL8jhUaiLLAcYUUZ6lopB6BoJYz ';
  String accuKey3 = 'm8hCvAjGScxuGfrcVQwahoFACgDIrTR5 ';

  Future<String> getLocationID(String location) async {
    //Make request to weather API
    Response locationID = await get(
        'http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$accuKey2&q=$location&metric=true');

    //Map data from request

    List city = jsonDecode(locationID.body);

    String id = city.first['Key'];
    return id;
  }

  Future<List<Weather>> getWeather(String id) async {
    Response response2 = await get(
        'http://dataservice.accuweather.com/forecasts/v1/daily/5day/$id?apikey=$accuKey2&metric=true');
    Map dailyWeather = jsonDecode(response2.body);

    List daily = (dailyWeather['DailyForecasts']);
    return daily.map((e) => Weather.fromJson(e)).toList();
  }
}
