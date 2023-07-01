import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shoping_app/main.dart';

class Views extends StatefulWidget {
  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  bool _isLoading = true; // Added indicator variable
  var _viewUrls = <String>[];
  @override
  void initState() {
    super.initState();
    download();
  }

  download() async {
    _viewUrls = [];
    final storageRef = FirebaseStorage.instance.ref('images/');
    final listResult = await storageRef.listAll();
    final listref = listResult.items;

    for (final ref in listref) {
      String url = await ref.getDownloadURL();
      setState(() {
        _viewUrls.add(url);
      });
    }

    setState(() {
      _isLoading = false; // Set isLoading to false after images are downloaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Joker-App"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => MyApp()));
              },
              icon: Icon(Icons.assignment_return)),
        ),
        body: RefreshIndicator(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(), // Show loading spinner
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Card(
                          child: Image.network(
                            _viewUrls[index],
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                    itemCount: _viewUrls.length,
                  ),
            onRefresh: () {
              return download();
            }));
  }
}
