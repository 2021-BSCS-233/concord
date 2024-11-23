import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String profileLink;
  final double? profileRadius;

  const ProfilePicture({super.key, required this.profileLink, this.profileRadius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: profileLink != ''
          ? CachedNetworkImageProvider(profileLink)
          : const AssetImage('assets/images/default.png') as ImageProvider,
      radius: 17,
      backgroundColor: Colors.grey.shade900,
    );
  }
}
