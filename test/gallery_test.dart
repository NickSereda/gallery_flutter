import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:photo_gallery_flutter/models/photo.dart';
import 'package:photo_gallery_flutter/models/result.dart';
import 'package:photo_gallery_flutter/networking/rest_client.dart';
import 'package:photo_gallery_flutter/provider/gallery_data.dart';

import 'gallery_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RestClient>()])
final _fakeData = Result(images: [
  Photo(url: 'fake_url_1'),
  Photo(url: 'fake_url_2'),
  Photo(url: 'fake_url_3'),
  Photo(url: 'fake_url_4'),
  Photo(url: 'fake_url_5'),
]);

void main() {
  late GalleryData galleryData;
  late MockRestClient client;

  setUp(() {
    client = MockRestClient();

    when(
      client.getPhotos(any, any, any, any),
    ).thenAnswer(
      (_) async => _fakeData,
    );

    galleryData = GalleryData(client);
  });

  group('Gallery test', () {
    test('galleryData get articles photos are empty', () {
      expect(
        galleryData.photosCount,
        0,
      );
    });

    test('galleryData initial page is 1', () {
      expect(
        galleryData.pageNumber,
        1,
      );
    });

    test(
        'galleryData.getPhotos() populates provider '
        'with photos', () async {
      await galleryData.getPhotos();
      expect(
        galleryData.photosCount,
        5,
      );
    });

    test(
        'galleryData.loadAnotherPage() adds new '
        'photos and increases page number', () async {
      // adds 5 photos (page is 1)
      await galleryData.getPhotos();
      await galleryData.loadAnotherPage();

      expect(
        galleryData.photosCount,
        10,
      );

      expect(
        galleryData.pageNumber,
        2,
      );
    });
  });
}
