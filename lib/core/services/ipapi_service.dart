import 'package:dio/dio.dart';
import 'package:iptracker/core/errors/failure.dart';
import 'package:iptracker/core/network/dio_client.dart';
import 'package:iptracker/core/result/result.dart';
import 'package:iptracker/core/services/ip_service.dart';
import 'package:iptracker/core/utils/ip_validator.dart';
import 'package:iptracker/features/ip_lookup/models/ip_data.dart';

class IPApiService implements IPService {
  final Dio _dio;
  final Map<String, IPData> _cache = {};
  
  IPApiService({DioClient? dioClient}) 
      : _dio = dioClient?.dio ?? Dio();
  
  @override
  String get providerName => 'ipapi.co';
  
  @override
  Future<Result<IPData>> getMyIPData() async {
    try {
      final response = await _dio.get('https://ipapi.co/json/');
      return Result.success(IPData.fromJson(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        return Result.failure(RateLimitFailure('Rate limit exceeded'));
      }
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
      final response = await _dio.get('https://ipapi.co/$ipAddress/json/');
      
      // Check for error response
      if (response.data is Map && response.data.containsKey('error')) {
        return Result.failure(IPNotFoundFailure(response.data['reason'] ?? 'IP not found'));
      }
      
      final ipData = IPData.fromJson(response.data);
      
      // Cache the result
      _cache[ipAddress] = ipData;
      
      return Result.success(ipData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        return Result.failure(RateLimitFailure('Rate limit exceeded'));
      }
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