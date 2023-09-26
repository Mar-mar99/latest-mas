import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:masbar/core/ui/widgets/profile/profile_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/auth/accounts/presentation/bloc/authentication_bloc.dart';
import '../app_dialog.dart';

class HelpItem extends StatelessWidget {
  const HelpItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileItem(
      icon: Icons.help_outline_sharp,
      text: AppLocalizations.of(context)?.help ?? "",
      onTap: () async {
        // try {
        //   if (await canLaunchUrl(
        //     Uri.parse(
        //       ApiConstants.helpUrl,
        //     ),
        //   )) {
        //     await launchUrl(
        //       Uri.parse(
        //         ApiConstants.helpUrl,
        //       ),
        //     );
        //   }
        // } catch (e) {
        //   print(e);
        // }
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return WebScreen();
          },
        ));
      },
    );
  }
}

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)  ..loadRequest(Uri.parse(ApiConstants.helpUrl));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.help)),
      body: WebViewWidget(controller: controller),
    );
  }
}
