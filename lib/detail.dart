import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './editdata.dart';
import 'package:http/http.dart' as http;
import './main.dart';

class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({required this.index,required this.list});
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<Detail> {

void deleteData(){
  var url="http://10.0.2.2/crud-flutter-api/deleteData.php";
  http.post(Uri.parse(url), body: {
    'id': widget.list[widget.index]['id']
  });
}

void confirm (){
  AlertDialog alertDialog = new AlertDialog(
    content: new Text("Are You sure want to delete '${widget.list[widget.index]['item_name']}'"),
    actions: <Widget>[
      new ElevatedButton(
        child: new Text("OK DELETE!",style: new TextStyle(color: Colors.black),),
        // color: Colors.red,
        style: ButtonStyle(
          foregroundColor:  WidgetStateProperty.all<Color>(Colors.red),
        ),
        onPressed: (){
          deleteData();
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context)=> new Home(),
            )
          );
        },
      ),
      new ElevatedButton(
        child: new Text("CANCEL",style: new TextStyle(color: Colors.black)),
        // color: Colors.green,
        style: ButtonStyle(
          foregroundColor:  WidgetStateProperty.all<Color>(Colors.green),
        ),
        onPressed: ()=> Navigator.pop(context),
      ),
    ],
  );

  // showDialog(context: context, child: alertDialog);
  showDialog(
    context: context,
    builder: (BuildContext context){
      return alertDialog;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("${widget.list[widget.index]['item_name']}")),
      body: new Container(
        height: 270.0, 
        padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
            child: new Column(
              children: <Widget>[

                new Padding(padding: const EdgeInsets.only(top: 30.0),),
                new Text(widget.list[widget.index]['item_name'], style: new TextStyle(fontSize: 20.0),),
                new Text("Code : ${widget.list[widget.index]['item_code']}", style: new TextStyle(fontSize: 18.0),),
                new Text("Price : ${widget.list[widget.index]['price']}", style: new TextStyle(fontSize: 18.0),),
                new Text("Stock : ${widget.list[widget.index]['stock']}", style: new TextStyle(fontSize: 18.0),),
                new Padding(padding: const EdgeInsets.only(top: 30.0),),

                new Row(
                  // mainAxisSurlize: MainAxisSize.min,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ElevatedButton(
                      child: new Text("EDIT"),
                      // color: Colors.green,
                      style: ButtonStyle(
                        foregroundColor:  WidgetStateProperty.all<Color>(Colors.green),
                        ),
                      onPressed: ()=>Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (BuildContext context)=>new EditData(list: widget.list, index: widget.index,),
                        )
                      ),
                    ),
                    new ElevatedButton(
                      child: new Text("DELETE"),
                      // color: Colors.red,
                      style: ButtonStyle(
                        foregroundColor:  WidgetStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: ()=>confirm(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
