import 'package:cached_network_image/cached_network_image.dart';
import 'package:elloro/appconstant/app_images.dart';
import 'package:elloro/screen/update_Account/update_account.dart';
import 'package:flutter/material.dart';

class CustomProfilePicture extends StatelessWidget {
  String? url;
  Function()? onTap;

  CustomProfilePicture({Key? key, required this.url, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateProfile()));
        },
        child: CachedNetworkImage(
          imageUrl: url!,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
            );
          },
          placeholder: (context, url) => const CircleAvatar(
            backgroundImage: AssetImage(Images.profileImage),
          ),
          errorWidget: (context, url, error) => const CircleAvatar(
            backgroundImage: AssetImage(Images.profileImage),
          ),
        )

        // CircleAvatar(
        //   backgroundImage: CachedNetworkImageProvider(url!),
        // ),

        );
  }
}
