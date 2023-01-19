import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  List<SearchList> userList = [];
  List<SearchList> search = [];
  TextEditingController editingController = TextEditingController();

  Future fetchData() async {
    String response = await rootBundle.loadString('assets/search.json');//load your json file here
    List jsonResult = await json.decode(response);
    // jsonResult.map((e) => SearchList.fromJson(e)).toList();
    List<SearchList> todo =
        jsonResult.map((dynamic item) => SearchList.fromJson(item)).toList();

    setState(() {
      userList = todo;
      search.addAll(userList);
      print("lis" + userList.length.toString());
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    search = userList;
  }

// This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<SearchList> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = userList;
    } else {
      results = userList
          .where((user) =>
              user.month!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      search = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                _runFilter(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
            const SizedBox(
              height: 20,
            ),
            search.isEmpty
                ? TextButton(
                    onPressed: () {
                      fetchData();
                    },
                    child: const Text('Load'),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: search.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                search[index].month.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: search[index].services!.length,
                                itemBuilder: (context, index2) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(search[index]
                                          .services![index2]
                                          .name
                                          .toString()),
                                      Text(search[index]
                                          .services![index2]
                                          .amount
                                          .toString()),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class SearchList {
  String? month;
  List<Services>? services;

  SearchList({this.month, this.services});

  SearchList.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? name;
  dynamic amount;

  Services({this.name, this.amount});

  Services.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}
