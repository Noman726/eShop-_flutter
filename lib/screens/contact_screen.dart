import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in Touch',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person_outline, color: color.primary),
              title: const Text('Noman'),
            ),
            ListTile(
              leading: Icon(Icons.email_outlined, color: color.primary),
              title: const Text('nomanpatel726@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone_outlined, color: color.primary),
              title: const Text('+91 8691991997'),
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined, color: color.primary),
              title: const Text('Jai Hind College'),
            ),
            const SizedBox(height: 24),
            Text(
              'Feel free to reach out to us for any queries, feedback, or support regarding ACE-thetic.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
