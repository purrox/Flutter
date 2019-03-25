import 'package:flutter/material.dart';
import 'package:api_example/screens/repositories.dart';
import 'package:api_example/entities/user.dart';
import 'package:api_example/services/githubService.dart' as githubService;

class UserScreen extends StatefulWidget {
  UserScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserScreen> {
  Future<User> user;

  final reposFinderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = githubService.fetchGitHubUser('purrox');
    reposFinderController.addListener(getGitUser);

  }

  getGitUser() {
    user = githubService.fetchGitHubUser(reposFinderController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            buildSearchTextInput(reposFinderController),
            Padding(padding: EdgeInsets.all(20.00)),
            FutureBuilder<User>(
              future: user,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return buildImage(snapshot.data.avatarUrl);
                }
                return Center(child: CircularProgressIndicator());
              },) ,
            buildTRaisedButton(reposFinderController.text)
          ],
        ),
      ),
    );
  }

  RaisedButton buildTRaisedButton(String user) {
    return RaisedButton(
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    (Reposotories(title: 'Flutter Demo Home Page', user:user))),
          );
        },
        child: new Text("Repositories",
            style: TextStyle(
                fontSize: 22.0,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold)),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)));
  }
}

Container buildImage(String img) {
  return Container(
      width: 190.0,
      height: 190.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black26,
            width: 8.0,
          ),
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(img))));
}

Row buildSearchTextInput(TextEditingController reposFinderController) {
  return Row(
    children: <Widget>[
      Expanded(
          child: TextField(
            controller: reposFinderController,
        decoration: InputDecoration(
            hintText: 'What is your username?',
            filled: true,
            suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {})),
        style: TextStyle(fontSize: 22.0),
      ))
    ],
  );
}
