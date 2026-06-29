import '../../../core/app_export.dart';

/// This class is used in the [gridleaderboard1_item_widget] screen.
class Gridleaderboard1ItemModel {
  Gridleaderboard1ItemModel({
    this.leaderboardText,
    this.id,
  }) {
    leaderboardText = leaderboardText ?? Rx("Leaderboard");
    id = id ?? Rx("");
  }

  Rx<String>? leaderboardText;

  Rx<String>? id;
}
