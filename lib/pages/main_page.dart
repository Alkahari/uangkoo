import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uangkoo/API/Authentications.dart';
import 'package:uangkoo/main.dart';
import 'package:uangkoo/models/database.dart';
import 'package:uangkoo/pages/category_page.dart';
import 'package:uangkoo/pages/home_page.dart';
import 'package:uangkoo/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, this.selectedDate}) : super(key: key);
  DateTime? selectedDate;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  final database = AppDb();

  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    updateView(0, DateTime.now());

    super.initState();
  }

  Future<List<Category>> getAllCategory() {
    return database.select(database.categories).get();
  }

  void showAwe() async {
    List<Category> al = await getAllCategory();
    print('PANJANG : ${al.length}');
  }

  void showSuccess(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("My title"),
      content: const Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }

      currentIndex = index;
      _children = [
        HomePage(
          selectedDate: selectedDate,
        ),
        const CategoryPage()
      ];
    });
  }

  void onTabTapped(int index) {
    setState(() {
      selectedDate =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      currentIndex = index;
      _children = [
        HomePage(
          selectedDate: selectedDate,
        ),
        const CategoryPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Visibility(
          visible: (currentIndex == 0) ? true : false,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) =>
                      TransactionPage(transactionsWithCategory: null),
                ))
                    .then((value) {
                  setState(() {
                    updateView(0, DateTime.now());
                  });
                });
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  updateView(0, DateTime.now());
                },
                icon: const Icon(Icons.home)),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  updateView(1, DateTime.now());
                },
                icon: const Icon(Icons.list))
          ],
        )),
        body: _children[currentIndex],
        appBar: (currentIndex == 1)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: GoogleFonts.montserrat(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: MyText("Logout", fontSize: 18,fontWeight: FontWeight.bold, color: Colors.green,),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: MyText("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Authentications().logout(context);
                                    },
                                    child: MyText("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : CalendarAppBar(
                fullCalendar: true,
                backButton: false,
                accent: Colors.green,
                selectedDate: widget.selectedDate ?? selectedDate,
                locale: 'en',
                onDateChanged: (value) {
                  setState(() {
                    widget.selectedDate = value;
                    selectedDate = value;
                    updateView(0, selectedDate);
                  });
                },
                lastDate: DateTime.now()));
  }
}
