import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shoping_app/main.dart';

class Views extends StatefulWidget {
  @override
  State<Views> createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  bool _isLoading = true;
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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joker-App"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => MyApp(),
            ));
          },
          icon: Icon(Icons.assignment_return),
        ),
      ),
      body: RefreshIndicator(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onLongPress: () {
                      _showImageOptionsDialog(context, _viewUrls[index]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Card(
                        child: Image.network(
                          _viewUrls[index],
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _viewUrls.length,
              ),
        onRefresh: () => download(),
      ),
    );
  }

  void _showImageOptionsDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Options'),
          content: Text('choisir une action pour cette image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeImage(imageUrl);
              },
              child: Text('Remove'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveImage(imageUrl);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _removeImage(String imageUrl) async {
    print('Removing image: $imageUrl');
    final reference = FirebaseStorage.instance.refFromURL(imageUrl);
    await reference.delete();
    download();
    // Implement your remove image logic here
  }

  void _saveImage(String imageUrl) {
    print('Saving image: $imageUrl');
    // Implement your save image logic here
  }
}
