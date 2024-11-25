import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProfilePicture extends StatelessWidget {
  final String profileLink;
  final double? profileRadius;

  const ProfilePicture(
      {super.key, required this.profileLink, this.profileRadius});

  @override
  Widget build(BuildContext context) {
    final profilePictureCache = CacheManager(Config(
      'profilePictureCache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 50,
    ));

    // return CircleAvatar(
    //   backgroundImage: profileLink != ''
    //       ? CachedNetworkImageProvider(profileLink,
    //           cacheManager: profilePictureCache)
    //       : const AssetImage('assets/images/default.png') as ImageProvider,
    //   radius: profileRadius,
    //   backgroundColor: Colors.grey.shade900,
    // );
    return CachedNetworkImage(
        imageUrl: profileLink,
        // cacheManager: profilePictureCache,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
              radius: profileRadius,
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundImage: const AssetImage('assets/images/default.png'),
              radius: profileRadius,
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundImage: const AssetImage('assets/images/default.png'),
              radius: profileRadius,
            ));
  }
}
