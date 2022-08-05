import 'package:photo_gallery_flutter/models/result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://pixabay.com/api")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/")
  Future<Result> getPhotos(
      @Query("key") String apiKey,
      @Query("per_page") int perPage,
      @Query("page") int pageNum,
      @Query("image_type") String imageType,
      );

}