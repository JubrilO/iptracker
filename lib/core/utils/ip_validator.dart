class IPValidator {
  /// Private constructor to prevent instantiation
  IPValidator._();
  
  /// Validates if a string is a valid IPv4 address
  static bool isValidIPv4(String ipAddress) {
    if (ipAddress.isEmpty) return false;
    
    final ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    );
    
    return ipRegex.hasMatch(ipAddress);
  }
}