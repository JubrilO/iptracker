import 'package:iptracker/core/result/result.dart';
import 'package:iptracker/core/services/ip_service_provider.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';

class IPRepository {
  final IPServiceProvider _serviceProvider;
  
  IPRepository({required IPServiceProvider serviceProvider}) 
      : _serviceProvider = serviceProvider;
  
  /// Get data for the user's current IP
  Future<Result<IPData>> getMyIPData() async {
    return _serviceProvider.currentService.getMyIPData();
  }
  
  /// Get data for a specific IP address
  Future<Result<IPData>> getIPData(String ipAddress) async {
    return _serviceProvider.currentService.getIPData(ipAddress);
  }
  
  /// Check if the provided string is a valid IP address
  bool isValidIPAddress(String ipAddress) {
    return _serviceProvider.currentService.isValidIPAddress(ipAddress);
  }
  
  /// Get the name of the currently active service
  String get currentServiceName => _serviceProvider.currentServiceName;
  
  /// Get a list of all available service names
  List<String> get availableServiceNames => _serviceProvider.availableServiceNames;
  
  /// Change the current service by name
  void changeService(String serviceName) {
    _serviceProvider.switchService(serviceName);
  }
}