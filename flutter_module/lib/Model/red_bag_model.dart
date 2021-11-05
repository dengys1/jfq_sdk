class RedBagModel {
  final String my_red_bag;
  final String history_red_bag;
  final String today_red_bag;
  final List exchange_list;

  RedBagModel({
    this.my_red_bag,
    this.history_red_bag,
    this.today_red_bag,
    this.exchange_list,
  });

  factory RedBagModel.fromJson(Map json) {
    return RedBagModel(
        my_red_bag: json['my_red_bag'].toString(),
        history_red_bag: json['history_red_bag'].toString(),
        today_red_bag: json['today_red_bag'].toString(),
        exchange_list: json['exchange_list']);
  }
}
