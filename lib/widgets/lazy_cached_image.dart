import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

final generalImageCache = CacheManager(Config(
  'generalImageCache',
  stalePeriod: const Duration(days: 7),
  maxNrOfCacheObjects: 50,
));

class LazyCachedImage extends StatelessWidget {
  final String url;

  const LazyCachedImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ImagePage(url: url));
      },
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/placeholder1.jpg'),
        imageBuilder: (context, imageProvider) => FadeInImage(
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/images/placeholder1.jpg'),
            image: imageProvider),
      ),

      // child: FadeInImage(
      //   image: CachedNetworkImageProvider(url,
      //       cacheManager: generalImageCache,scale: 0.5, errorListener: (error){print('error loading image $error');}),
      //   placeholder: const AssetImage('assets/images/placeholder1.jpg'),
      //   fit: BoxFit.cover,
      // ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final String url;

  const ImagePage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
            child: CachedNetworkImage(
          imageUrl: url,
          cacheManager: generalImageCache,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )),
      ),
    );
  }
}
