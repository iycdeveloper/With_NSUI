import '../../../core/app_export.dart';

/// This class is used in the [userpost1_item_widget] screen.
class UserPostItemModel {
  UserPostItemModel({
    this.image,
    this.hightwo,
    this.postimageinface,
    this.likes,
    this.id,
  }) {
    image = image ?? Rx("Image");
    hightwo = hightwo ?? Rx("High");
    postimageinface = postimageinface ?? Rx("Post image in Facebook");
    likes = likes ?? Rx("10");
    id = id ?? Rx("");
  }

  Rx<String>? image;

  Rx<String>? hightwo;

  Rx<String>? postimageinface;

  Rx<String>? likes;

  Rx<String>? id;
}
