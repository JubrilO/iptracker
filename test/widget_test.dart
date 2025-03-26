// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:iptracker/main.dart';
import 'package:iptracker/core/network/dio_client.dart';
import 'package:iptracker/features/ip_lookup/repository/ip_repository.dart';
import 'package:iptracker/features/ip_lookup/view_models/home_view_model.dart';
import 'package:iptracker/features/ip_lookup/view_models/map_view_model.dart';
import 'package:iptracker/core/services/ip_service_provider.dart';

void main() {
  testWidgets('IPTracker app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<DioClient>(create: (_) => DioClient()),
          ChangeNotifierProvider<IPServiceProvider>(
            create: (context) => IPServiceProvider(
              dioClient: context.read<DioClient>(),
            ),
          ),
          Provider<IPRepository>(
            create: (context) => IPRepository(
              serviceProvider: context.read<IPServiceProvider>(),
            ),
          ),
          ChangeNotifierProvider<HomeViewModel>(
            create: (context) => HomeViewModel(
              ipRepository: context.read<IPRepository>(),
            ),
          ),
          ChangeNotifierProvider<MapViewModel>(
            create: (_) => MapViewModel(),
          ),
        ],
        child: const IPTrackerApp(),
      ),
    );

    // Verify that the app starts with the home screen
    expect(find.text('IPTracker'), findsOneWidget);
    expect(find.text('Enter an IPv4 address (e.g., 8.8.8.8)'), findsOneWidget);
  });
}
