import 'package:flutter/material.dart';
import 'screens/about_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/dashboard/admin/admin_categories_screen.dart';
import 'screens/dashboard/admin/admin_create_category_screen.dart';
import 'screens/dashboard/admin/admin_edit_category_screen.dart';
import 'screens/dashboard/admin/admin_items_screen.dart';
import 'screens/dashboard/admin/admin_users_screen.dart';
import 'screens/dashboard/admin/admin_dashboard_screen.dart';
import 'screens/dashboard/buyer/buyer_items_screen.dart';
import 'screens/dashboard/buyer/buyer_profile_screen.dart';
import 'screens/dashboard/buyer/buyer_dashboard_screen.dart';
import 'screens/dashboard/seller/seller_items_screen.dart';
import 'screens/dashboard/seller/seller_create_item_screen.dart';
import 'screens/dashboard/seller/seller_edit_item_screen.dart';
import 'screens/dashboard/seller/seller_profile_screen.dart';
import 'screens/dashboard/seller/seller_dashboard_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/items/items_screen.dart';
import 'screens/items/item_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/':
      case '/items':
        return MaterialPageRoute(builder: (_) => ItemsScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case '/contact':
        return MaterialPageRoute(builder: (_) => ContactScreen());
      case '/faq':
        return MaterialPageRoute(builder: (_) => FAQScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/items/:id':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ItemDetailScreen(itemId: args),
          );
        }
        return _errorRoute();
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => MainScreen(initialIndex: 1));
      case '/dashboard/admin':
        return MaterialPageRoute(builder: (_) => AdminDashboardScreen());
      case '/dashboard/admin/categories':
        return MaterialPageRoute(builder: (_) => AdminCategoriesScreen());
      case '/dashboard/admin/categories/create':
        return MaterialPageRoute(builder: (_) => AdminCreateCategoryScreen());
      case '/dashboard/admin/categories/:id/edit':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => AdminEditCategoryScreen(categoryId: args),
          );
        }
        return _errorRoute();
      case '/dashboard/admin/items':
        return MaterialPageRoute(builder: (_) => AdminItemsScreen());
      case '/dashboard/admin/users':
        return MaterialPageRoute(builder: (_) => AdminUsersScreen());
      case '/dashboard/buyer':
        return MaterialPageRoute(builder: (_) => BuyerDashboardScreen());
      case '/dashboard/buyer/items':
        return MaterialPageRoute(builder: (_) => BuyerItemsScreen());
      case '/dashboard/buyer/profile':
        return MaterialPageRoute(builder: (_) => BuyerProfileScreen());
      case '/dashboard/seller':
        return MaterialPageRoute(builder: (_) => SellerDashboardScreen());
      case '/dashboard/seller/items':
        return MaterialPageRoute(builder: (_) => SellerItemsScreen());
      case '/dashboard/seller/items/create':
        return MaterialPageRoute(builder: (_) => SellerCreateItemScreen());
      case '/dashboard/seller/items/:id/edit':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => SellerEditItemScreen(itemId: args),
          );
        }
        return _errorRoute();
      case '/dashboard/seller/profile':
        return MaterialPageRoute(builder: (_) => SellerProfileScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => MainScreen(initialIndex: 2));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(child: Text('Page not found')),
        );
      },
    );
  }
}
