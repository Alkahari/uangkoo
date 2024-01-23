import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uangkoo/API/Authentications.dart';

class TransactionsAPI {
  var dio = Dio();
  void createTransactions(int id, String description, int category_id,
      String transaction_date, String amount) async {
    var email = await getEmail();
    var data = {
      "id": id,
      "email": email,
      "description": description,
      "category_id": category_id,
      "transaction_date": transaction_date,
      "amount": amount,
    };
    var result = await dio.post(
      "$BaseUrl/api/transaction/create_transaction.php",
      data: FormData.fromMap(data),
    );
    print(result.statusCode);
  }

  void deleteTransaction(int id) async {
    var data = {"id": id};
    var result = await dio.post(
      "$BaseUrl/api/transaction/delete_transaction.php",
      data: FormData.fromMap(data),
    );
    print(result);
  }

  void updateTransaction(
    int id,
    String description,
    int category_id,
    String transaction_date,
    String amount,
  ) async {
    var email = await getEmail();
    print("id sama dengan " + id.toString());
    print(email);
    print(description);
    print(category_id);
    print(transaction_date);
    print(amount);
    var data = {
      "transaction_id": id,
      "email": email,
      "description": description,
      "category_id": category_id,
      "transaction_date": transaction_date,
      "amount": amount,
    };
    var result = await dio.post(
      "$BaseUrl/api/transaction/update_transaction.php",
      data: FormData.fromMap(data),
    );
    print(result.statusCode);
  }

  Future<Map<String, String>> getAmount(String date) async {
    var email = await getEmail();
    var incomeData = {
      "email": email,
      "type": 1,
      "date": date
    }; // Assuming 1 is for income type
    var expenseData = {
      "email": email,
      "type": 2,
      "date": date
    }; // Assuming 2 is for expense type

    var incomeResponse = await dio.post(
      "$BaseUrl/api/transaction/get_amount.php",
      data: FormData.fromMap(incomeData),
    );

    var expenseResponse = await dio.post(
      "$BaseUrl/api/transaction/get_amount.php",
      data: FormData.fromMap(expenseData),
    );
    print("HEYYYYYY");
    print(incomeResponse.data);
    print(expenseResponse.data);

    return {"income": incomeResponse.data ?? "0", "expense": expenseResponse.data ?? "0"};
  }
}
