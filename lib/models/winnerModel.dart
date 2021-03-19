class WinnerModel {
  final String name;
  final String ludoName;
  final int winner_prize;

  WinnerModel({
    this.name,
    this.ludoName,
    this.winner_prize,
  });

  WinnerModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        ludoName = json['ludoName'],
        winner_prize = json['winner_prize'];
}
