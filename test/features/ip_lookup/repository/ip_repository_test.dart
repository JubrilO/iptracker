import 'package:flutter_test/flutter_test.dart';
import 'package:iptracker/core/errors/failure.dart';
import 'package:iptracker/core/result/result.dart';
import 'package:iptracker/core/services/ip_service.dart';
import 'package:iptracker/core/services/ip_service_provider.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';
import 'package:iptracker/features/ip_lookup/repository/ip_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([IPServiceProvider, IPService])
import 'ip_repository_test.mocks.dart';

void main() {
  late IPRepository repository;
  late MockIPServiceProvider mockServiceProvider;
  late MockIPService mockIPService;

  setUp(() {
    mockIPService = MockIPService();
    mockServiceProvider = MockIPServiceProvider();
    
    // Set up the mock service provider to return the mock IP service
    when(mockServiceProvider.currentService).thenReturn(mockIPService);
    when(mockServiceProvider.currentServiceName).thenReturn('Mock Service');
    when(mockServiceProvider.availableServiceNames).thenReturn(['Mock Service', 'Another Service']);
    
    repository = IPRepository(serviceProvider: mockServiceProvider);
  });

  group('getIPData', () {
    const testIPAddress = '8.8.8.8';
    final testIPData = IPData(
      ipAddress: testIPAddress,
      latitude: 37.751,
      longitude: -97.822,
      city: 'Mountain View',
      country: 'United States',
    );

    test('should return successful Result when service call is successful', () async {
      // Arrange
      when(mockIPService.getIPData(testIPAddress))
          .thenAnswer((_) async => Result.success(testIPData));

      // Act
      final result = await repository.getIPData(testIPAddress);

      // Assert
      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.data, testIPData);
      verify(mockIPService.getIPData(testIPAddress)).called(1);
    });

    test('should return failure Result when service call fails', () async {
      // Arrange
      final failure = NetworkFailure('Network error');
      when(mockIPService.getIPData(testIPAddress))
          .thenAnswer((_) async => Result.failure(failure));

      // Act
      final result = await repository.getIPData(testIPAddress);

      // Assert
      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.failure, equals(failure));
      verify(mockIPService.getIPData(testIPAddress)).called(1);
    });
  });

  group('getMyIPData', () {
    final testIPData = IPData(
      ipAddress: '8.8.8.8',
      latitude: 37.751,
      longitude: -97.822,
      city: 'Mountain View',
      country: 'United States',
    );

    test('should return successful Result when service call is successful', () async {
      // Arrange
      when(mockIPService.getMyIPData())
          .thenAnswer((_) async => Result.success(testIPData));

      // Act
      final result = await repository.getMyIPData();

      // Assert
      expect(result.isSuccess, true);
      expect(result.data, testIPData);
      verify(mockIPService.getMyIPData()).called(1);
    });

    test('should return failure Result when service call fails', () async {
      // Arrange
      final failure = ServerFailure('Server error');
      when(mockIPService.getMyIPData())
          .thenAnswer((_) async => Result.failure(failure));

      // Act
      final result = await repository.getMyIPData();

      // Assert
      expect(result.isSuccess, false);
      expect(result.failure, equals(failure));
      verify(mockIPService.getMyIPData()).called(1);
    });
  });

  group('isValidIPAddress', () {
    test('should call service isValidIPAddress method', () {
      // Arrange
      when(mockIPService.isValidIPAddress('8.8.8.8')).thenReturn(true);
      when(mockIPService.isValidIPAddress('invalid')).thenReturn(false);

      // Act & Assert
      expect(repository.isValidIPAddress('8.8.8.8'), true);
      expect(repository.isValidIPAddress('invalid'), false);
      verify(mockIPService.isValidIPAddress('8.8.8.8')).called(1);
      verify(mockIPService.isValidIPAddress('invalid')).called(1);
    });
  });

  group('service provider functions', () {
    test('should return currentServiceName from provider', () {
      // Act & Assert
      expect(repository.currentServiceName, 'Mock Service');
      verify(mockServiceProvider.currentServiceName).called(1);
    });

    test('should return availableServiceNames from provider', () {
      // Act & Assert
      expect(repository.availableServiceNames, ['Mock Service', 'Another Service']);
      verify(mockServiceProvider.availableServiceNames).called(1);
    });

    test('should call switchService on provider when changeService is called', () {
      // Act
      repository.changeService('Another Service');
      
      // Assert
      verify(mockServiceProvider.switchService('Another Service')).called(1);
    });
  });
}