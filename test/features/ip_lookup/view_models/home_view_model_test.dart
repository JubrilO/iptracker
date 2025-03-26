// test/features/ip_lookup/view_models/home_view_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:iptracker/core/errors/failure.dart';
import 'package:iptracker/core/result/result.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';
import 'package:iptracker/features/ip_lookup/repository/ip_repository.dart';
import 'package:iptracker/features/ip_lookup/view_models/home_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([IPRepository])
import 'home_view_model_test.mocks.dart';

void main() {
  late HomeViewModel viewModel;
  late MockIPRepository mockRepository;

  setUp(() {
    mockRepository = MockIPRepository();
    
    // Set up mock service provider methods
    when(mockRepository.availableServiceNames).thenReturn(['Service 1', 'Service 2']);
    when(mockRepository.currentServiceName).thenReturn('Service 1');
    
    viewModel = HomeViewModel(ipRepository: mockRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('getIPAddress', () {
    final testIPData = IPData(
      ipAddress: '8.8.8.8',
      latitude: 37.751,
      longitude: -97.822,
      city: 'Mountain View',
      country: 'United States',
    );

    test('should update ipAddressController when successful', () async {
      // Arrange
      when(mockRepository.getMyIPData()).thenAnswer(
        (_) async => Result.success(testIPData),
      );

      // Act
      await viewModel.getIPAddress();

      // Assert
      expect(viewModel.ipAddressController.text, '8.8.8.8');
      expect(viewModel.isLoading, false);
    });

    test('should emit error when fails', () async {
      // Arrange
      when(mockRepository.getMyIPData()).thenAnswer(
        (_) async => Result.failure(NetworkFailure('Network error')),
      );

      // Act & Assert
      expectLater(viewModel.errorStream, emits('Network error: Please check your internet connection'));
      await viewModel.getIPAddress();
      expect(viewModel.isLoading, false);
    });
  });

  group('submitIPAddress', () {
    final testIPData = IPData(
      ipAddress: '8.8.8.8',
      latitude: 37.751,
      longitude: -97.822,
      city: 'Mountain View',
      country: 'United States',
    );

    test('should return IPData when successful', () async {
      // Arrange
      viewModel.ipAddressController.text = '8.8.8.8';
      when(mockRepository.isValidIPAddress('8.8.8.8')).thenReturn(true);
      when(mockRepository.getIPData('8.8.8.8')).thenAnswer(
        (_) async => Result.success(testIPData),
      );

      // Act
      final result = await viewModel.submitIPAddress();

      // Assert
      expect(result, testIPData);
      expect(viewModel.isLoading, false);
      verify(mockRepository.getIPData('8.8.8.8')).called(1);
    });

    test('should emit error and return null when IP is empty', () async {
      // Arrange
      viewModel.ipAddressController.text = '';

      // Act & Assert
      expectLater(viewModel.errorStream, emits('Please enter an IP address'));
      final result = await viewModel.submitIPAddress();
      expect(result, null);
      verifyNever(mockRepository.getIPData(any));
    });

    test('should emit error and return null when IP is invalid', () async {
      // Arrange
      viewModel.ipAddressController.text = 'invalid';
      when(mockRepository.isValidIPAddress('invalid')).thenReturn(false);

      // Act & Assert
      expectLater(viewModel.errorStream, emits('Invalid IP format. Please enter a valid IPv4 address (e.g., 8.8.8.8)'));
      final result = await viewModel.submitIPAddress();
      expect(result, null);
      verifyNever(mockRepository.getIPData(any));
    });

    test('should emit error and return null when API fails', () async {
      // Arrange
      viewModel.ipAddressController.text = '8.8.8.8';
      when(mockRepository.isValidIPAddress('8.8.8.8')).thenReturn(true);
      when(mockRepository.getIPData('8.8.8.8')).thenAnswer(
        (_) async => Result.failure(ServerFailure('Server error')),
      );

      // Act & Assert
      expectLater(viewModel.errorStream, emits('Server error: Please try again later'));
      final result = await viewModel.submitIPAddress();
      expect(result, null);
      expect(viewModel.isLoading, false);
      verify(mockRepository.getIPData('8.8.8.8')).called(1);
    });
  });

  group('service provider operations', () {
    test('should get service names from repository', () {
      // Act & Assert
      expect(viewModel.availableServiceNames, ['Service 1', 'Service 2']);
      expect(viewModel.currentServiceName, 'Service 1');
      verify(mockRepository.availableServiceNames).called(1);
      verify(mockRepository.currentServiceName).called(1);
    });

    test('should call changeService method on repository', () {
      // Arrange
      final notifierCalled = <bool>[];
      viewModel.addListener(() {
        notifierCalled.add(true);
      });
      
      // Act
      viewModel.changeService('Service 2');
      
      // Assert
      verify(mockRepository.changeService('Service 2')).called(1);
      expect(notifierCalled, [true]); // Should notify listeners
    });
    
    test('should clear IP address when service is changed', () {
      // Arrange
      viewModel.ipAddressController.text = '8.8.8.8';
      
      // Act
      viewModel.changeService('Service 2');
      
      // Assert
      expect(viewModel.ipAddressController.text, '');
      verify(mockRepository.changeService('Service 2')).called(1);
    });
  });

  group('clearIPAddress', () {
    test('should clear ipAddressController', () {
      // Arrange
      viewModel.ipAddressController.text = '8.8.8.8';
      
      // Act
      viewModel.clearIPAddress();
      
      // Assert
      expect(viewModel.ipAddressController.text, '');
    });
  });
}