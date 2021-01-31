// To parse this JSON data, do
//
//     final photo = photoFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

List<Photo> photosFromJson(String str) =>
    List<Photo>.from(json.decode(str).map((x) => Photo.fromJson(x)));

String photosToJson(List<Photo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Photo photoFromJson(String str) => Photo.fromJson(json.decode(str));

String photoToJson(Photo data) => json.encode(data.toJson());

User userFromJson(String str) => User.fromJson(json.decode(str));

List<Collection> collectionFromJson(String str) =>
    List<Collection>.from(json.decode(str).map((x) => Collection.fromJson(x)));

String collectionToJson(List<Collection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

SearchResult searchResultFromJson(String str) =>
    SearchResult.fromJson(json.decode(str));

String searchResultToJson(SearchResult data) => json.encode(data.toJson());

class Photo extends Equatable {
  Photo({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.likes,
    this.likedByUser,
    this.description,
    this.user,
    this.currentUserCollections,
    this.urls,
    this.links,
  });

  String id;
  DateTime createdAt;
  DateTime updatedAt;
  int width;
  int height;
  String color;
  String blurHash;
  int likes;
  bool likedByUser;
  String description;
  User user;
  List<CurrentUserCollection> currentUserCollections;
  Urls urls;
  PhotoLinks links;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        likes: json["likes"],
        likedByUser: json["liked_by_user"],
        description: json["description"],
        user: User.fromJson(json["user"]),
        currentUserCollections: List<CurrentUserCollection>.from(
            json["current_user_collections"]
                .map((x) => CurrentUserCollection.fromJson(x))),
        urls: Urls.fromJson(json["urls"]),
        links: PhotoLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "likes": likes,
        "liked_by_user": likedByUser,
        "description": description,
        "user": user.toJson(),
        "current_user_collections":
            List<dynamic>.from(currentUserCollections.map((x) => x.toJson())),
        "urls": urls.toJson(),
        "links": links.toJson(),
      };

  @override
  List<Object> get props => [
        id,
        likedByUser,
      ];
}

class CurrentUserCollection {
  CurrentUserCollection({
    this.id,
    this.title,
    this.publishedAt,
    this.lastCollectedAt,
    this.updatedAt,
    this.coverPhoto,
    this.user,
  });

  String id;
  String title;
  DateTime publishedAt;
  DateTime lastCollectedAt;
  DateTime updatedAt;
  dynamic coverPhoto;
  dynamic user;

  factory CurrentUserCollection.fromJson(Map<String, dynamic> json) =>
      CurrentUserCollection(
        id: json["id"],
        title: json["title"],
        publishedAt: DateTime.parse(json["published_at"]),
        lastCollectedAt: DateTime.parse(json["last_collected_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        coverPhoto: json["cover_photo"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "published_at": publishedAt.toIso8601String(),
        "last_collected_at": lastCollectedAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "cover_photo": coverPhoto,
        "user": user,
      };
}

class PhotoLinks {
  PhotoLinks({
    this.self,
    this.html,
    this.download,
    this.downloadLocation,
  });

  String self;
  String html;
  String download;
  String downloadLocation;

  factory PhotoLinks.fromJson(Map<String, dynamic> json) => PhotoLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
        downloadLocation: json["download_location"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "download": download,
        "download_location": downloadLocation,
      };
}

class Urls {
  Urls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
  });

  String raw;
  String full;
  String regular;
  String small;
  String thumb;

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
      };
}

class User extends Equatable {
  User(
      {this.id,
      this.username,
      this.name,
      this.portfolioUrl,
      this.bio,
      this.location,
      this.totalLikes,
      this.totalPhotos,
      this.totalCollections,
      this.instagramUsername,
      this.twitterUsername,
      this.profileImage,
      this.links,
      this.followersCount,
      this.followingCount});

  String id;
  String username;
  String name;
  String portfolioUrl;
  String bio;
  String location;
  int totalLikes;
  int totalPhotos;
  int totalCollections;
  String instagramUsername;
  String twitterUsername;
  ProfileImage profileImage;
  UserLinks links;
  int followersCount;
  int followingCount;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      name: json["name"],
      portfolioUrl: json["portfolio_url"],
      bio: json["bio"],
      location: json["location"],
      totalLikes: json["total_likes"],
      totalPhotos: json["total_photos"],
      totalCollections: json["total_collections"],
      instagramUsername: json["instagram_username"],
      twitterUsername: json["twitter_username"],
      profileImage: ProfileImage.fromJson(json["profile_image"]),
      links: UserLinks.fromJson(json["links"]),
      followersCount: json["followers_count"],
      followingCount: json["following_count"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "portfolio_url": portfolioUrl,
        "bio": bio,
        "location": location,
        "total_likes": totalLikes,
        "total_photos": totalPhotos,
        "total_collections": totalCollections,
        "instagram_username": instagramUsername,
        "twitter_username": twitterUsername,
        "profile_image": profileImage.toJson(),
        "links": links.toJson(),
        "followers_count": followersCount,
        "following_count": followingCount
      };

  @override
  List<Object> get props => [id, username, name];
}

class UserLinks {
  UserLinks({
    this.self,
    this.html,
    this.photos,
    this.likes,
    this.portfolio,
  });

  String self;
  String html;
  String photos;
  String likes;
  String portfolio;

  factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
        self: json["self"],
        html: json["html"],
        photos: json["photos"],
        likes: json["likes"],
        portfolio: json["portfolio"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "photos": photos,
        "likes": likes,
        "portfolio": portfolio,
      };
}

class ProfileImage {
  ProfileImage({
    this.small,
    this.medium,
    this.large,
  });

  String small;
  String medium;
  String large;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
        "large": large,
      };
}

class Collection {
  Collection({
    this.id,
    this.title,
    this.description,
    this.publishedAt,
    this.lastCollectedAt,
    this.updatedAt,
    this.totalPhotos,
    this.private,
    this.shareKey,
    this.coverPhoto,
    this.user,
    this.links,
  });

  String id;
  String title;
  String description;
  DateTime publishedAt;
  DateTime lastCollectedAt;
  DateTime updatedAt;
  int totalPhotos;
  bool private;
  String shareKey;
  CoverPhoto coverPhoto;
  User user;
  CollectionLinks links;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        publishedAt: DateTime.parse(json["published_at"]),
        lastCollectedAt: DateTime.parse(json["last_collected_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        totalPhotos: json["total_photos"],
        private: json["private"],
        shareKey: json["share_key"],
        coverPhoto: CoverPhoto.fromJson(json["cover_photo"]),
        user: User.fromJson(json["user"]),
        links: CollectionLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "published_at": publishedAt.toIso8601String(),
        "last_collected_at": lastCollectedAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "total_photos": totalPhotos,
        "private": private,
        "share_key": shareKey,
        "cover_photo": coverPhoto.toJson(),
        "user": user.toJson(),
        "links": links.toJson(),
      };
}

class CoverPhoto {
  CoverPhoto({
    this.id,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.likes,
    this.likedByUser,
    this.description,
    this.user,
    this.urls,
    this.links,
  });

  String id;
  int width;
  int height;
  String color;
  String blurHash;
  int likes;
  bool likedByUser;
  String description;
  User user;
  Urls urls;
  CoverPhotoLinks links;

  factory CoverPhoto.fromJson(Map<String, dynamic> json) {
    return json != null
        ? CoverPhoto(
            id: json["id"],
            width: json["width"],
            height: json["height"],
            color: json["color"],
            blurHash: json["blur_hash"],
            likes: json["likes"],
            likedByUser: json["liked_by_user"],
            description: json["description"],
            user: User.fromJson(json["user"]),
            urls: Urls.fromJson(json["urls"]),
            links: CoverPhotoLinks.fromJson(json["links"]),
          )
        : null;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "likes": likes,
        "liked_by_user": likedByUser,
        "description": description,
        "user": user.toJson(),
        "urls": urls.toJson(),
        "links": links.toJson(),
      };
}

class CoverPhotoLinks {
  CoverPhotoLinks({
    this.self,
    this.html,
    this.download,
  });

  String self;
  String html;
  String download;

  factory CoverPhotoLinks.fromJson(Map<String, dynamic> json) =>
      CoverPhotoLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "download": download,
      };
}

class CollectionLinks {
  CollectionLinks({
    this.self,
    this.html,
    this.photos,
    this.related,
  });

  String self;
  String html;
  String photos;
  String related;

  factory CollectionLinks.fromJson(Map<String, dynamic> json) =>
      CollectionLinks(
        self: json["self"],
        html: json["html"],
        photos: json["photos"],
        related: json["related"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "photos": photos,
        "related": related,
      };
}

class SearchResult {
  SearchResult({
    this.total,
    this.totalPages,
    this.results,
  });

  int total;
  int totalPages;
  List<Photo> results;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        total: json["total"],
        totalPages: json["total_pages"],
        results:
            List<Photo>.from(json["results"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
