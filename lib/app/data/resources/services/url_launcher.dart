import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else if (await canLaunch("https://" + link)) {
      await launch("https://" + link);
    } else {
      throw 'Could not launch $link';
    }
  }
}
