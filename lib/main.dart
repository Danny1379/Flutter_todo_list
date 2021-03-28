// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList()
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _listItems = [] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readData();
  }
  void _addNewItem(String task){
    if(task.length > 0){
      setState(() => _listItems.add(task));
    }
  }


  void _removeTodoItem(int index){
    setState(() => _listItems.removeAt(index)) ;
    _saveData();
  }


  void _promptRemoveTodoItem(int index){
    showDialog(
      context: context ,
      builder: (BuildContext context){
        return new AlertDialog(
          title : new Text("Do you want to remove '${_listItems[index]}'?"),
          actions: <Widget>[
            new TextButton(
              child: new Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new TextButton(
              child: new Text('Yes'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop() ;
              }
            )
          ]
        );
      }
    );
  }
  Widget _buildTodoList(){
    return new ListView.builder(
      // ignore: missing_return
      itemBuilder: (context , index){
        if(index < _listItems.length){
          return _buildItem(_listItems[index],index);
        }
      },
    );
  }
  _saveData() async{
    String jsonString = jsonEncode(_listItems);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jsonList', jsonString);
  }

  _readData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('jsonList');
    List<dynamic> jsonList = jsonDecode(jsonString) ;
    _listItems = jsonList.map((n) => n.toString()).toList();
  }
  void _pushAddTodoScreen(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Please enter your task'),
            ),
            body: new TextField(
              autofocus: true,
              autocorrect: true,
              onSubmitted: (task){
                _addNewItem(task) ;
                _saveData();
                Navigator.of(context).pop();
              },
              decoration: new InputDecoration(
                hintText: "you want to..." ,
                contentPadding: const EdgeInsets.all(16.0)
              ),
            ),
          );
        }
      )
    );
  }
  Widget _buildTodoItem(String todoText,int index){
    return new ListTile(
      title: new Text(todoText),
      onTap: () => _promptRemoveTodoItem(index),
      tileColor: Color(0x42583D1C),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
        appBar: new AppBar(
          backgroundColor:  Color(0xFF65422F),
            title: new Text('Todo List')
        ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: "new task" ,
        child: new Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(String todoText,int index,) {
    return new Container(
      child: _buildTodoItem(todoText, index),
      decoration: new BoxDecoration(
        border: Border.all(width: 1.0,color: Color(0x000000))
      ),
    );
  }
}


