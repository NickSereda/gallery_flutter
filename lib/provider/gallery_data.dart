import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery_flutter/models/result.dart';
import 'package:photo_gallery_flutter/networking/rest_client.dart';

import '../keys.dart';

class GalleryData extends ChangeNotifier {
  int _pageNumber = 1;

  List<String> _photos = [];

  final RestClient _restClient = RestClient(Dio());

  int get photosCount {
    return _photos.length;
  }

  UnmodifiableListView<String> get photos {
    return UnmodifiableListView(_photos);
  }

  Future<void> getPhotos() async {

    final Result result = await _restClient.getPhotos(pixabyAPIKey, 20, _pageNumber, "photo");

    _photos = result.images.map((e) => e.url).toList();

    notifyListeners();
  }

  Future<void> loadAnotherPage() async {

    final Result result = await _restClient.getPhotos(pixabyAPIKey, 20, _pageNumber + 1, "photo");

    _photos.addAll(result.images.map((e) => e.url));

    notifyListeners();
  }
}
