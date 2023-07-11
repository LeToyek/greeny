class UserModel {
  String email;
  String? name;
  String? imageUrl;
  int level;
  int exp;
  String? photoFrame;

  UserModel({
    required this.email,
    this.name = "name",
    this.imageUrl,
    this.level = 1,
    this.exp = 0,
    this.photoFrame,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        imageUrl = json['image_url'],
        level = json['level'],
        exp = json['exp'],
        photoFrame = json['photo_frame'];
}
