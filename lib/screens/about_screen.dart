import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About ACE-thetic'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.surface, color.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Welcome to ACE-thetic',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Your Trusted Fashion Marketplace',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ACE-thetic is your modern online destination for buying and selling clothes and fashion accessories. Discover the latest trends, shop from trusted sellers, and enjoy a seamless shopping experience. Whether you are looking for new arrivals, exclusive deals, or want to sell your own products, ACE-thetic is the place for you.',
                style: textTheme.bodyMedium?.copyWith(
                  color: color.onBackground.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Features:',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(context, '• Browse a wide range of clothes and fashion items.'),
              _buildBulletPoint(context, '• Manage your profile and orders with ease.'),
              _buildBulletPoint(context, '• Secure payments and trusted sellers.'),
              _buildBulletPoint(context, '• Easy-to-use dashboard for buyers, sellers, and admins.'),
              _buildBulletPoint(context, '• Modern, responsive UI with dark/light mode.'),
              const SizedBox(height: 24),
              Text(
                'Start shopping today and discover your next favorite outfit with ACE-thetic!',
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: color.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            ),
      ),
    );
  }
}
