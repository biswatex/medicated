import 'package:flutter/material.dart';
class DataSearch extends SearchDelegate<String>{
  final data =[
    "hello",
    "alen jones",
    "shantanu",
    "pal",
  ];
  final history =[
    "hello"
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(icon:Icon(Icons.clear),onPressed: (){
          query ="";
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return
      IconButton(icon:AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),onPressed: (){
          close(context, null);
      },);
  }

  @override
  Widget buildResults(BuildContext context) {
      return Container(
        child: Text(query),
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
      final historyData = query.isEmpty?history:data.where((element) => element.startsWith(query)).toList();
      return ListView.builder(itemBuilder: (context,index)=>ListTile(
        onTap: (){
          showResults(context);
        },
        title: RichText(text:TextSpan(
          text: historyData[index].substring(0,query.length),
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: historyData[index].substring(query.length),
            style: TextStyle(color: Colors.grey),
      ),
        ]
        )
        ),
        leading: Icon(Icons.history),
      ),
        itemCount:historyData.length,
      );
  }

}