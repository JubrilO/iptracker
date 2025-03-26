import 'package:flutter/material.dart';
import 'package:iptracker/core/network/dio_client.dart';
import 'package:iptracker/core/services/ip_service.dart';
import 'package:iptracker/core/services/ipapi_service.dart';
import 'package:iptracker/core/services/ipify_service.dart';

/// Service provider that manages which IP service is currently active
class IPServiceProvider extends ChangeNotifier {
  final DioClient _dioClient;
  
  // List of available services
  late final List<IPService> _availableServices;
  
  // Currently selected service
  late IPService _currentService;
  
  IPServiceProvider({required DioClient dioClient}) : _dioClient = dioClient {
    _availableServices = [
      IPApiService(dioClient: _dioClient),
      IPifyService(dioClient: _dioClient),
    ];
    
    // Default to the first service
    _currentService = _availableServices.first;
  }
  
  // Get the list of available service names for UI dropdowns
  List<String> get availableServiceNames => 
      _availableServices.map((service) => service.providerName).toList();
  
  // Get the current service
  IPService get currentService => _currentService;
  
  // Get the current service name
  String get currentServiceName => _currentService.providerName;
  
  // Switch to a different service by name
  void switchService(String serviceName) {
    final service = _availableServices.firstWhere(
      (service) => service.providerName == serviceName,
      orElse: () => _availableServices.first
    );
    
    if (service != _currentService) {
      _currentService = service;
      notifyListeners();
    }
  }
} 