import 'package:FlutterGalleryApp/model/photo.dart';
import 'package:FlutterGalleryApp/provider/photo_api_provider.dart';

class UnsplashRepository {
  PhotoApiProvider _photoApiProvider = PhotoApiProvider();

  Future<List<Photo>> fetchPhotos(int page, int perPage) =>
      _photoApiProvider.fetchPhotos(page, perPage);

  Future<Photo> fetchPhoto(String id) => _photoApiProvider.fetchPhoto(id);

  Future<User> fetchMyUserProfile() => _photoApiProvider.fetchMyUserProfile();

  Future<User> fetchUserProfile(String authorId) =>
      _photoApiProvider.fetchUserProfile(authorId);

  Future<List<Photo>> fetchUserPhoto(String user, int page, int perPage) =>
      _photoApiProvider.fetchUserPhoto(user, page, perPage);

  Future<List<Photo>> fetchUserLikes(String user, int page, int perPage) =>
      _photoApiProvider.fetchUserLikes(user, page, perPage);

  Future<List<Collection>> fetchUserCollections(
          String user, int page, int perPage) =>
      _photoApiProvider.fetchUserCollections(user, page, perPage);

  Future<List<Photo>> fetchPhotoOfCollection(
          String collectionId, int page, int perPage) =>
      _photoApiProvider.fetchPhotoOfCollection(collectionId, page, perPage);

  Future<Photo> likePhoto(String photoId) =>
      _photoApiProvider.likePhoto(photoId);

  Future<bool> unlikePhoto(String photoId) =>
      _photoApiProvider.unlikePhoto(photoId);

  Future<SearchResult> searchPhoto(String text, int page, int perPage) =>
      _photoApiProvider.searchPhoto(text, page, perPage);
}
