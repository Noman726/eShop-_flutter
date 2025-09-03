import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Frequently Asked Questions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildFAQItem(
              context,
              question: 'How do I purchase an item?',
              answer:
                  'Browse the available products, select your favorite, and tap "Buy Now" to complete your purchase securely.',
            ),
            _buildFAQItem(
              context,
              question: 'How do I track my orders?',
              answer:
                  'Go to your profile, then "My Orders" to track the status of your purchases.',
            ),
            _buildFAQItem(
              context,
              question: 'How do I contact customer support?',
              answer:
                  'Navigate to the Contact Us section from the drawer menu and reach out via email or phone.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, {required String question, required String answer}) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answer,
              style: textTheme.bodyMedium?.copyWith(
                color: color.onBackground.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
