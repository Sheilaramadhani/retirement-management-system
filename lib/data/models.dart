
class Investment {
  final String symbol;
  final String name;
  final double value;

  Investment({required this.symbol, required this.name, required this.value});

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      value: json['value'] as double,
    );
  }

  get id => null;

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'value': value,
    };
  }
}

class Account {
  final String id;
  final String type;
  final double balance;

  Account({required this.id, required this.type, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      type: json['type'] as String,
      balance: json['balance'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'balance': balance,
    };
  }
}
