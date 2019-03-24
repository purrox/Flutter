import 'package:flutter/material.dart';
import 'package:api_example/services/githubService.dart' as githubService;
import 'package:api_example/entities/user.dart';
import 'package:api_example/entities/repos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<User> user;
  Future<List<Repos>> repos;

  final reposFinderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = githubService.fetchGitHubUser();
    repos = githubService.fetchGitHubUserRepos('purrox');
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
                      return CircularProgressIndicator();
                    }))
          ],
        )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
