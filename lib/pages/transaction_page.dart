import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangkoo/API/TransactionsAPI.dart';
import 'package:uangkoo/main.dart';
import 'package:uangkoo/models/database.dart';
import 'package:uangkoo/models/transaction_with_category.dart';
import 'package:uangkoo/pages/main_page.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionsWithCategory;
  TransactionPage(
      {Key? key, required this.transactionsWithCategory, this.isEdit})
      : super(key: key);

  bool? isEdit;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  
  bool isExpense = true;
  late int type;
  final AppDb database = AppDb();
  Category? selectedCategory;
  List<Category> categoryList = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future insert(
      String description, int categoryId, int amount, DateTime date) async {
    DateTime now = DateTime.now();
    final row = await database
        .into(database.transactions)
        .insertReturning(
          TransactionsCompanion.insert(
              description: description,
              category_id: categoryId,
              amount: amount,
              transaction_date: date,
              created_at: now,
              updated_at: now),
        )
        .then((value) {
      TransactionsAPI().createTransactions(
        value.id,
        descriptionController.value.text,
        selectedCategory!.id,
        dateController.text,
        amountController.value.text,
      );
    });
  }

  update(Transaction updatedTransaction) async {
    final result = await database.updateTransaction(updatedTransaction);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyText(
          "Success",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: PRIMARY_COLOR,
        ),
      ),
    );
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.transactionsWithCategory != null) {
      updateTransaction(widget.transactionsWithCategory!);
    } else {
      type = 2;

      dateController.text = "";
    }
    initializeCategory();

    super.initState();
  }

  void initializeCategory() async {
    categoryList = await getAllCategory(type);
    selectedCategory = categoryList[0];
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  void updateTransaction(TransactionWithCategory initTransaction) {
    amountController.text = initTransaction.transaction.amount.toString();
    descriptionController.text =
        initTransaction.transaction.description.toString();
    dateController.text = DateFormat('yyyy-MM-dd')
        .format(initTransaction.transaction.transaction_date);
    type = initTransaction.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory = initTransaction.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.isEdit == true)
            ? "Update Transaction"
            : "Create Transaction"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Switch(
                  // This bool value toggles the switch.
                  value: isExpense,
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      isExpense = value;
                      type = (isExpense) ? 2 : 1;
                      selectedCategory = null;
                    });
                  },
                ),
                Text(
                  isExpense ? "Expense" : "Income",
                  style: GoogleFonts.montserrat(fontSize: 14),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Amount',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Category", style: GoogleFonts.montserrat()),
            ),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder<List<Category>>(
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton<Category>(
                          isExpanded: true,
                          value: (selectedCategory == null)
                              ? snapshot.data!.first
                              : selectedCategory,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          onChanged: (Category? newValue) {
                            print(newValue!.name);
                            setState(() {
                              selectedCategory = newValue;
                            });
                          },
                          items: snapshot.data!.map((Category value) {
                            return DropdownMenuItem<Category>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return const Text("Belum ada kategory");
                    }
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    print(
                        formattedDate); //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      dateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (widget.isEdit == true) {
                    update(
                      Transaction(
                        id: widget.transactionsWithCategory!.transaction.id,
                        description: descriptionController.value.text,
                        category_id: selectedCategory!.id,
                        transaction_date:
                            DateTime.parse(dateController.value.text),
                        amount: int.parse(amountController.value.text),
                        created_at: DateTime.now(),
                        updated_at: DateTime.now(),
                      ),
                    );
                    TransactionsAPI().updateTransaction(
                      widget.transactionsWithCategory!.transaction.id,
                      descriptionController.value.text,
                      selectedCategory!.id,
                      dateController.value.text,
                      amountController.value.text,
                    );
                  } else {
                    insert(
                        descriptionController.value.text,
                        selectedCategory!.id,
                        int.parse(amountController.value.text),
                        DateTime.parse(dateController.text));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(
                            selectedDate: DateTime.parse(
                              dateController.value.text,
                            ),
                          ),
                        ));
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
