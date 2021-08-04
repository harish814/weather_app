import 'package:geolocator/geolocator.dart';

class Location{
  double longitude;
  double latitude;

  Future<void> getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      
      longitude = position.longitude;
      latitude = position.latitude;
    }catch(e){
      print(e);
    }
  }
}