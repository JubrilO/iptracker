import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';
import 'package:iptracker/features/ip_lookup/repository/ip_repository.dart';
import 'package:iptracker/core/errors/failure.dart';

class HomeViewModel extends ChangeNotifier {
  final IPRepository _ipRepository;
  final _errorController = StreamController<String>.broadcast();
  final TextEditingController ipAddressController = TextEditingController();
  
  Stream<String> get errorStream => _errorController.stream;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  HomeViewModel({required IPRepository ipRepository}) 
      : _ipRepository = ipRepository;
  
  @override
  void dispose() {
    _errorController.close();
    ipAddressController.dispose();
    super.dispose();
  }
  
  /// Get the user's current IP address
  Future<void> getIPAddress() async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _ipRepository.getMyIPData();
    
    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          _errorController.add('Network error: Please check your internet connection');
        } else if (failure is RateLimitFailure) {
          _errorController.add('Rate limit exceeded: Please try again in a few minutes');
        } else {
          _errorController.add(failure.message);
        }
      },
      (ipData) {
        ipAddressController.text = ipData.ipAddress;
      },
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Clear the IP address input field
  void clearIPAddress() {
    ipAddressController.clear();
    notifyListeners();
  }
  
  /// Get the list of available service names for the dropdown
  List<String> get availableServiceNames => _ipRepository.availableServiceNames;
  
  /// Get the current service name
  String get currentServiceName => _ipRepository.currentServiceName;
  
  /// Switch to a different IP service provider
  void changeService(String serviceName) {
    _ipRepository.changeService(serviceName);
    ipAddressController.clear();
    notifyListeners();
  }
  
  /// Submit an IP address for geolocation lookup
  Future<IPData?> submitIPAddress() async {
    final ipAddress = ipAddressController.text.trim();
    
    if (ipAddress.isEmpty) {
      _errorController.add('Please enter an IP address');
      return null;
    }
    
    if (!_ipRepository.isValidIPAddress(ipAddress)) {
      _errorController.add('Invalid IP format. Please enter a valid IPv4 address (e.g., 8.8.8.8)');
      return null;
    }
    
    _isLoading = true;
    notifyListeners();
    
    final result = await _ipRepository.getIPData(ipAddress);
    
    _isLoading = false;
    notifyListeners();
    
    return result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          _errorController.add('Network error: Please check your internet connection');
        } else if (failure is RateLimitFailure) {
          _errorController.add('Rate limit exceeded: Please try again in a few minutes');
        } else if (failure is IPNotFoundFailure) {
          _errorController.add('IP address not found or invalid');
        } else if (failure is ServerFailure) {
          _errorController.add('Server error: Please try again later');
        } else {
          _errorController.add(failure.message);
        }
        return null;
      },
      (ipData) => ipData,
    );
  }
}