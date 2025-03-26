import 'package:iptracker/core/result/result.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';

/// Abstract base class for all IP information providers
abstract class IPService {
  /// Provider name for display in UI
  String get providerName;
  
  /// Get IP data for the current user's IP address
  Future<Result<IPData>> getMyIPData();
  
  /// Get IP data for a specific IP address
  Future<Result<IPData>> getIPData(String ipAddress);
  
  /// Validate if a string is a valid IP address format
  bool isValidIPAddress(String ipAddress);
}