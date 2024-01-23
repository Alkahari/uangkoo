import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangkoo/API/TransactionsAPI.dart';
import 'package:uangkoo/models/database.dart';
import 'package:uangkoo/models/transaction_with_category.dart';
import 'package:uangkoo/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();

  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    refresh();
    super.initState();
  }

  // page controller

  Future delete(int transactionId) async {
    await database.deleteTransaction(transactionId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Icon(
                                    Icons.download,
                                    color: Colors.greenAccent[400],
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Income',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12, color: Colors.white)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Rp 3.800.000',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14, color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Icon(
                                    Icons.upload,
                                    color: Colors.redAccent[400],
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Expense',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12, color: Colors.white)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('Rp 1.600.000',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14, color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Transactions",
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<List<TransactionWithCategory>>(
                stream: database.getTransactionByDateRepo(widget.selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Card(
                                  elevation: 10,
                                  child: ListTile(
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              delete(
                                                snapshot.data![index]
                                                    .transaction.id!,
                                              );
                                              TransactionsAPI()
                                                  .deleteTransaction(snapshot
                                                      .data![index]
                                                      .transaction
                                                      .id!);
                                              setState(() {});
                                            }),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionPage(
                                                          transactionsWithCategory:
                                                              snapshot.data![
                                                                  index], isEdit: true,),
                                                ))
                                                .then((value) {});
                                          },
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                        snapshot.data![index].category.name),
                                    leading: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: (snapshot.data![index].category
                                                    .type ==
                                                1)
                                            ? Icon(
                                                Icons.download,
                                                color: Colors.greenAccent[400],
                                              )
                                            : Icon(
                                                Icons.upload,
                                                color: Colors.red[400],
                                              )),
                                    title: Text(
                                      snapshot.data![index].transaction.amount
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Column(children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text("Belum ada transaksi",
                                style: GoogleFonts.montserrat()),
                          ]),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text("Belum ada transaksi"),
                      );
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
