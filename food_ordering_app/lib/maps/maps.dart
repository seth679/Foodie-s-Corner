import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapsUtils
{
  MapsUtils._();

  //latitude longitude
  static Future<void> openMapWithPosition(double latitude, double longitude) async{
    String googleMapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    if(await canLaunchUrlString(googleMapUrl)){
      await launchUrlString(googleMapUrl);
    }
    else{
      throw "Could not open the map.";
    }
  }

  //textual address
  static Future<void> openMapWithAddress(String fullAddress) async{
    String query = Uri.encodeComponent(fullAddress);
    Uri googleMapUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if(await canLaunchUrl(googleMapUrl)){
      await launchUrl(googleMapUrl);
    }
    else{
      throw "Could not open the map.";
    }

  }

  static Future<void> navigateTo(double latitude, double longitude) async
  {
    var uri = Uri.parse("google.navigation:q=$latitude,$longitude&mode=d");
    if(await canLaunchUrl(uri)){
      await launchUrl(uri);
    }
    else{
      throw "Could not open the map.";
    }
  }
}