import 'package:flutter/material.dart';
import 'package:socialmediaapp/utils/constants.dart';

dynamic buildCachedImagePlaceHolder(
    String? imageUrl, BuildContext context) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return buildImagePlaceHolder(defaultPostImage, context);
  }

  return buildImagePlaceHolder(imageUrl, context);
}

Widget buildImagePlaceHolder(String imagePath, BuildContext context) {
  return 
    Image.network(
    imagePath,
    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null ? 
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
        ),
      );
    },
    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
      return const Text('Could not load image');
    },
  );
}

ImageProvider<Object> buildImageProviderPlaceHolder(
    String? imagePath, BuildContext context) {
  if (imagePath == null || imagePath.isEmpty) {
    return Image.network(
      defaultProfileImage,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
    ).image;
  }
  return Image.network(
    imagePath,
    fit: BoxFit.cover,
    width: MediaQuery.of(context).size.width,
  ).image;
}
