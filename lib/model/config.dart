class Config {
  String _urlDev = 'http://10.0.2.2:2226/api/dev/';
  // String _urlDev = 'http://192.168.1.115:3000/api/';
  // final url = Uri.parse('http://192.168.1.115:3000/api/auth/getOtp');
  String _urlDevLive = 'http://103.77.206.78:2226/api/dev/';

  Map<String, String> header(String? token) {
    if (token != null) {
      Map<String, String> headerHttp = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "token": token
      };
      return headerHttp;
    } else {
      Map<String, String> headerHttp = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      };
      return headerHttp;
    }
  }

  String get urlDev {
    return _urlDev;
  }

  String get urlDevLive {
    return _urlDevLive;
  }
}
