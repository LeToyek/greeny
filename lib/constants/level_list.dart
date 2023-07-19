class LevelModel {
  final int level;
  final int exp;

  LevelModel({required this.level, required this.exp});
}

final List<LevelModel> levelList = [
  LevelModel(level: 1, exp: 0),
  LevelModel(level: 2, exp: 100),
  LevelModel(level: 3, exp: 300),
  LevelModel(level: 4, exp: 600),
  LevelModel(level: 5, exp: 1000),
  LevelModel(level: 6, exp: 1500),
  LevelModel(level: 7, exp: 2100),
  LevelModel(level: 8, exp: 2800),
  LevelModel(level: 9, exp: 3600),
  LevelModel(level: 10, exp: 4500),
];
