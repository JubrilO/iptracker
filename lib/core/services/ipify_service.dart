import 'package:dio/dio.dart';
import 'package:iptracker/core/errors/failure.dart';
import 'package:iptracker/core/network/dio_client.dart';
import 'package:iptracker/core/result/result.dart';
import 'package:iptracker/core/services/ip_service.dart';
import 'package:iptracker/core/utils/ip_validator.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';

class IPifyService implements IPService {
  final Dio _dio;
  final Map<String, IPData> _cache = {};
  
  IPifyService({DioClient? dioClient}) 
      : _dio = dioClient?.dio ?? Dio();
  
  @override
  String get providerName => 'ipify.org';
  
  @override
  Future<Result<IPData>> getMyIPData() async {
    try {
      // First get the IP from ipify
      final ipResponse = await _dio.get('https://api.ipify.org?format=json');
      final ipAddress = ipResponse.data['ip'];
      
      // Then get location data from ip-api.com
      return getIPData(ipAddress);
    } on DioException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Result.failure(NetworkFailure(e.toString()));
    }
  }
  
  @override
  Future<Result<IPData>> getIPData(String ipAddress) async {
    // Check cache first
    if (_cache.containsKey(ipAddress)) {
      return Result.success(_cache[ipAddress]!);
    }
    
    try {
      // Use ip-api.com for geolocation data
      final response = await _dio.get('http://ip-api.com/json/$ipAddress');
      
      if (response.data is Map && response.data['status'] == 'fail') {
        return Result.failure(IPNotFoundFailure(response.data['message'] ?? 'IP not found'));
      }
      
      // Map the response to our IPData model
      final ipData = IPData(
        ipAddress: ipAddress,
        latitude: response.data['lat'],
        longitude: response.data['lon'],
        city: response.data['city'],
        country: response.data['country'],
      );
      
      // Cache the result
      _cache[ipAddress] = ipData;
      
      return Result.success(ipData);
    } on DioException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Result.failure(NetworkFailure(e.toString()));
    }
  }
  
  @override
  bool isValidIPAddress(String ipAddress) {
    return IPValidator.isValidIPv4(ipAddress);
  }
}