class ApiConstants {
  ApiConstants._();

  // Replace with your deployed proxy URL (see shivi-proxy/)
  static const String proxyBaseUrl = 'http://localhost:3000';
  static const String chatEndpoint = '$proxyBaseUrl/api/chat';

  static const int timeoutSeconds = 30;
}
