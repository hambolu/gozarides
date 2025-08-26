import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final List<Transaction> transactions;
  final DateTime lastUpdated;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.transactions,
    required this.lastUpdated,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map, String id) {
    return WalletModel(
      id: id,
      userId: map['userId'] ?? '',
      balance: (map['balance'] ?? 0.0).toDouble(),
      transactions: (map['transactions'] as List?)
          ?.map((x) => Transaction.fromMap(x))
          .toList() ??
          [],
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'balance': balance,
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}

class Transaction {
  final String type; // 'credit' or 'debit'
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status;
  final String? reference;

  Transaction({
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
    this.reference,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      type: map['type'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: map['status'] ?? '',
      reference: map['reference'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
      'reference': reference,
    };
  }
}
