import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Detail.dart';
import './adddata.dart';

void main() {
  runApp(MaterialApp(
    title: "My Store",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getData();
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse("http://192.168.56.1/crud-flutter-api/getdata.php"));
    return json.decode(response.body);
  }

  void _refreshData() {
    setState(() {
      _futureData = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Flutter"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AddData(),
          ),
        ),
      ),
      body: RefreshIndicator(
        notificationPredicate: true ? (_) => true : (_) => false,
        onRefresh: () async {
          _refreshData();
          // Return a Future to complete the refresh
          await _futureData;
        },
        child: FutureBuilder<List>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? ItemList(
                    list: snapshot.data ?? [],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Detail(list: list, index: i),
              ),
            ),
            child: Card(
              child: ListTile(
                title: Text(list[i]['item_name']),
                leading: Icon(Icons.widgets),
                subtitle: Text("Stock : ${list[i]['stock']}"),
              ),
            ),
          ),
        );
      },
    );
  }
}
