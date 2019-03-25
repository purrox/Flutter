import 'package:api_example/services/githubService.dart' as githubService;
import 'package:api_example/entities/user.dart';
import 'package:api_example/entities/repos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reposotories extends StatefulWidget {
  Reposotories({Key key, this.title, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String user;

  @override
  _ReposPageState createState() => _ReposPageState();
}

class _ReposPageState extends State<Reposotories> {
  Future<List<Repos>> repos;

  final reposFinderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    repos = githubService.fetchGitHubUserRepos(widget.user);
    reposFinderController.addListener(getReposByUser);
  }

  getReposByUser() {
    repos = githubService.fetchGitHubUserRepos(reposFinderController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
          children: <Widget>[
            TextField(
              controller: reposFinderController,
              decoration: InputDecoration(
                  hintText: 'Please enter a search term',
                  filled: true,
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        getReposByUser();
                      })),
              style: TextStyle(fontSize: 22.0),
            ),
            Expanded(
                child: FutureBuilder<List<Repos>>(
                    future: repos,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
                            return Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(Icons.stars,
                                           size: 30),
                                      Padding(padding: EdgeInsets.all(10.00),),    
                                      Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Text(
                                              "${snapshot.data[index].name}",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.bold)))
                                    ],
                                  )),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            "No repost for ${reposFinderController.text}");
                      }
                      return Center(child: CircularProgressIndicator());
                    }))
          ],
        )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
