abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class RateLimitFailure extends Failure {
  RateLimitFailure(super.message);
}

class IPNotFoundFailure extends Failure {
  IPNotFoundFailure(super.message);
}

class InvalidIPAddressFailure extends Failure {
  InvalidIPAddressFailure(super.message);
}