class Constant {
  static bool debug = true;

  static const String baseUrl = "https://www.wanandroid.com/";

  static const int successCode = 0;

  static const int invalidateToken = -1001;

  static const int otherError = -9999;

  static const String HOME = "首页";
  static const String PROJECT = "项目";
  static const String SQUARE = "广场";
  static const String MINE = "我的";
}

enum HttpMethod {
  Get(1, "GET"),
  Post(2, "POST"),
  Delete(3, "DELETE"),
  Put(4, "PUT");

  final int code;
  final String name;

  const HttpMethod(this.code, this.name);
}
