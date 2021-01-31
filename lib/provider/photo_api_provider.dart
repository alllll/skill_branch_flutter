import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoApiProvider {
  String baseUrl = "https://api.unsplash.com/";
  final succesCode = 200;
  String clientId = "kqm3H046orpfR6mStQgUb-o11rd1wE7ADjHJzQDHFwY";
  Dio dio;

  PhotoApiProvider() {
    // dio = new Dio(new BaseOptions(baseUrl: baseUrl));
  }

  Future<void> initDio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("token")) {
      var token = prefs.getString("token");
      print(token);
      dio = new Dio(new BaseOptions(
          baseUrl: baseUrl, headers: {'Authorization': 'Bearer $token'}));
    } else {
      dio = new Dio(new BaseOptions(baseUrl: baseUrl));
    }
  }

  Future<List<Photo>> fetchPhotos(int page, int perPage) async {
    await initDio();
    final Response<String> response = await dio.get("/photos",
        queryParameters: {
          "client_id": clientId,
          "page": page,
          "per_page": perPage
        });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      //     print(response.data.toString());
      return photosFromJson(response.data);
    } else
      Exception("failed load photos");
  }

  Future<Photo> fetchPhoto(String id) async {
    await initDio();
    final Response<String> response =
        await dio.get("/photos/" + id, queryParameters: {
      "client_id": clientId,
    });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      //    print(response.data.toString());
      return photoFromJson(response.data);
    } else
      Exception("failed load photo");
  }

  Future<User> fetchMyUserProfile() async {
    await initDio();
    final Response<String> response =
        await dio.get("/me", queryParameters: {"client_id": clientId});
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      //    print(response.data.toString());
      return userFromJson(response.data);
    } else
      Exception("failed load my profile");
  }

  Future<User> fetchUserProfile(String authorId) async {
    await initDio();
    final Response<String> response = await dio
        .get("/users/$authorId", queryParameters: {"client_id": clientId});
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      return userFromJson(response.data);
    } else
      Exception("failed load my profile");
  }

  Future<List<Photo>> fetchUserPhoto(String user, int page, int perPage) async {
    await initDio();
    final Response<String> response = await dio.get("/users/$user/photos",
        queryParameters: {
          "client_id": clientId,
          "page": page,
          "per_page": perPage
        });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      // print(response.data.toString());
      return photosFromJson(response.data);
    } else
      Exception("failed load user photos");
  }

  Future<List<Photo>> fetchUserLikes(String user, int page, int perPage) async {
    await initDio();
    final Response<String> response = await dio.get("/users/$user/likes",
        queryParameters: {
          "client_id": clientId,
          "page": page,
          "per_page": perPage
        });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      // print(response.data.toString());
      return photosFromJson(response.data);
    } else
      Exception("failed load likes");
  }

  Future<List<Collection>> fetchUserCollections(
      String user, int page, int perPage) async {
    await initDio();
    final Response<String> response = await dio.get("/users/$user/collections",
        queryParameters: {
          "client_id": clientId,
          "page": page,
          "per_page": perPage
        });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      // print(response.data.toString());
      return collectionFromJson(response.data);
    } else
      Exception("failed load likes");
  }

  Future<List<Photo>> fetchPhotoOfCollection(
      String collectionId, int page, int perPage) async {
    await initDio();
    final Response<String> response = await dio
        .get("/collections/$collectionId/photos", queryParameters: {
      "client_id": clientId,
      "page": page,
      "per_page": perPage
    });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      // print(response.data.toString());
      return photosFromJson(response.data);
    } else
      Exception("failed load photos");
  }

  Future<Photo> likePhoto(String id) async {
    await initDio();
    final Response<String> response = await dio
        .post("/photos/$id/like", queryParameters: {"client_id": clientId});
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      // print(response.data.toString());
      return photoFromJson(response.data);
    } else
      Exception("failed load photos");
  }

  Future<bool> unlikePhoto(String id) async {
    await initDio();
    final Response<String> response = await dio
        .delete("/photos/$id/like", queryParameters: {"client_id": clientId});
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == 204) {
      return true;
    } else
      Exception("failed load photos");
  }

  Future<SearchResult> searchPhoto(String text, int page, int perPage) async {
    await initDio();
    final Response<String> response = await dio.get("/search/photos",
        queryParameters: {"query": text, "page": page, "per_page": perPage});
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      return searchResultFromJson(response.data);
    } else
      Exception("failed search photos");
  }

  Future<SearchResult> searchPhotoRelated(String id) async {
    await initDio();
    dio.options.baseUrl = "https://unsplash.com";
    final Response<String> response =
        await dio.get("/napi/photos/$id/related", queryParameters: {
      "client_id": clientId,
    });
    print(response.headers["X-Ratelimit-Remaining"]);
    if (response.statusCode == succesCode) {
      return searchResultFromJson(response.data);
    } else
      Exception("failed search photos");
  }
}
