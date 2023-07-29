import 'package:flutter/foundation.dart';

class PostModel {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upvotes;
  final List<String> downVotes;
  final int commentCount;
  final String userName;
  final String uid;
  final String type;
  final DateTime dateTime;
  final List<String> awards;
  PostModel({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfilePic,
    required this.upvotes,
    required this.downVotes,
    required this.commentCount,
    required this.userName,
    required this.uid,
    required this.type,
    required this.dateTime,
    required this.awards,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upvotes,
    List<String>? downVotes,
    int? commentCount,
    String? userName,
    String? uid,
    String? type,
    DateTime? dateTime,
    List<String>? awards,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      userName: userName ?? this.userName,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'upvotes': upvotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'userName': userName,
      'uid': uid,
      'type': type,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      title: map['title'],
      link: map['link'],
      description: map['description'],
      communityName: map['communityName'],
      communityProfilePic: map['communityProfilePic'],
      upvotes: map['upvotes'] != null ? List<String>.from(map['upvotes']) : [],
      downVotes:
          map['downvotes'] != null ? List<String>.from(map['downvotes']) : [],
      commentCount: map['commentCount'] as int,
      userName: map['userName'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      awards: List<String>.from((map['awards'])),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityProfilePic: $communityProfilePic, upvotes: $upvotes, downVotes: $downVotes, commentCount: $commentCount, userName: $userName, uid: $uid, type: $type, dateTime: $dateTime, awards: $awards)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        other.communityName == communityName &&
        other.communityProfilePic == communityProfilePic &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downVotes, downVotes) &&
        other.commentCount == commentCount &&
        other.userName == userName &&
        other.uid == uid &&
        other.type == type &&
        other.dateTime == dateTime &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        description.hashCode ^
        communityName.hashCode ^
        communityProfilePic.hashCode ^
        upvotes.hashCode ^
        downVotes.hashCode ^
        commentCount.hashCode ^
        userName.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        dateTime.hashCode ^
        awards.hashCode;
  }
}
