import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/settings.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          title: Text(
            'No User Data is Collected',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('App does not collect any user data '
              '(tap for the full text).'),
          onTap: () => launchUrl(Uri.parse(urlPrivacyPolicy)),
        ),
        const SizedBox(height: 12, width: 0),
      ],
    );
  }
}
