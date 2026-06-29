import '../../../core/app_export.dart';

/// This class is used in the [slider1_item_widget] screen.
class Slider1ItemModel {
  Slider1ItemModel({this.id}) {
    id = id ?? Rx("");
  }

  Rx<String>? id;
}
