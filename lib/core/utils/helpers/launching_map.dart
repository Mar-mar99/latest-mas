import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchingMapHelper {
  static Future launchMap(double lat, double lng, String title) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showMarker(
        title: title,
        coords: Coords(
          lat,
          lng,
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  static Future showGoogleMap(double lat, double lng) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    }
  }

  static Future showAppleMap(double lat, double lng) async {
    final String appleUrl = 'https://maps.apple.com/?sll=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(appleUrl))) {
      await launchUrl(Uri.parse(appleUrl));
    }
  }
}
