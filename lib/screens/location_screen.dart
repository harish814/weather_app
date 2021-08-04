import 'package:flutter/material.dart';
import 'package:climat/utilities/constants.dart';
import 'package:climat/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  LocationScreen({this.locationWeather});
  final locationWeather;
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temp;
  String weatherIcon;
  String weatherMessage;
  String city;
  void initState(){
    super.initState();
    updateUi(widget.locationWeather);
  }

  void updateUi(dynamic weatherData){
    setState(() {
      if(weatherData == null){
        temp = 0;
        city = '';
        weatherIcon = 'Error';
        weatherMessage = 'Unable to featch the weather';
        return;
      }
    double temperature = weatherData['main']['temp'];
    temp = temperature.toInt();
    var condition = weatherData['weather'][0]['id'];
    city = weatherData['name'];
    weatherIcon = weather.getWeatherIcon(condition);
    weatherMessage = weather.getMessage(temp);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async{
                      var weatherData = await weather.getWeatherData();
                      updateUi(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedname = await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }));
                      print(typedname);

                      if(typedname != null){

                        var weatherData = await weather.getCityWeather(typedname);
                        updateUi(weatherData);
                        print(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $city",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
