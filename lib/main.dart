// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

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


  void _addNewItem(String task){
    if(task.length > 0){
      setState(() => _listItems.add(task));
    }
  }


  void _removeTodoItem(int index){
    setState(() => _listItems.removeAt(index)) ;
  }


  void _promptRemoveTodoItem(int index){
    showDialog(
      context: context ,
      builder: (BuildContext context){
        return new AlertDialog(
          title : new Text("Do you want to remove '${_listItems[index]}'?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
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
          return _buildTodoItem(_listItems[index],index);
        }
      },
    );
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
      onTap: () => _promptRemoveTodoItem(index)
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFF6EDDC),
        appBar: new AppBar(
          backgroundColor:  Color(0xFF745E4D),
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
}


