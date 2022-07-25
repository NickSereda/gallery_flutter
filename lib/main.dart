import 'package:flutter/material.dart';
import 'package:photo_gallery_flutter/provider/gallery_data.dart';
import 'package:photo_gallery_flutter/screens/photo_gallery_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GalleryData()..getPhotos(),
      child: MaterialApp(
        theme: ThemeData.dark(),
       home: PhotoGalleryProviderScreen(),
      ),
    );
  }
}
