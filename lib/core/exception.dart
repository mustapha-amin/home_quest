class NoInternetException implements Exception {
  @override
  String toString() {
    return "No internet connection was found\nCheck your internet connection and try again";
  }  
}