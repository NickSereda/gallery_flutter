import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery_flutter/networking/rest_client.dart';
import 'package:photo_gallery_flutter/provider/gallery_data.dart';
import 'package:photo_gallery_flutter/screens/photo_gallery_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GalleryData(
        RestClient(
          Dio(),
        ),
      )..getPhotos(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: PhotoGalleryProviderScreen(),
      ),
    );
  }
}
