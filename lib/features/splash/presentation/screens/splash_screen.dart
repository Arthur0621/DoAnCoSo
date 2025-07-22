import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneynest/core/constants/app_colors.dart';
import 'package:moneynest/core/database/database_provider.dart';
import 'package:moneynest/core/router/app_router.dart';
import 'package:moneynest/core/router/routes.dart';
import 'package:moneynest/core/utils/logger.dart';
import 'package:moneynest/features/authentication/presentation/riverpod/auth_provider.dart';
import 'package:moneynest/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import for useEffect

class SplashScreen extends HookConsumerWidget {
  // Changed to HookConsumerWidget
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Use useEffect to run side effects once when the widget is built
    useEffect(() {
      Future<void> initializeApp() async {
        // Initialize database (this also triggers onCreate population services)
        final db = ref.read(databaseProvider);
        Log.d(db.schemaVersion, label: 'schema version');

        // Fetch currencies and populate the static provider
        // Using ref.read(currenciesProvider.future) to get the future directly
        try {
          final currencyList = await ref.read(currenciesProvider.future);
          ref.read(currenciesStaticProvider.notifier).state = currencyList;
          Log.d(currencyList.length, label: 'currencies populated');
        } catch (e) {
          Log.e(
            'Failed to load currencies for static provider',
            label: 'currencies',
          );
        }

        // Check user session and navigate
        final auth = ref.read(authStateProvider.notifier);
        final user = await auth.getSession();
        if (context.mounted) {
          // Ensure context is still valid
          if (user == null) {
            GoRouter.of(rootNavKey.currentContext!).go(Routes.onboarding);
          } else {
            GoRouter.of(rootNavKey.currentContext!).go(Routes.main);
          }
        }
      }

      initializeApp();
      return null; // useEffect requires a dispose function or null
    }, const []); // Empty dependency array means this runs once

    return const Scaffold(
      backgroundColor: AppColors.primary50,
      body: Center(child: Text('Splash')),
    );
  }
}
