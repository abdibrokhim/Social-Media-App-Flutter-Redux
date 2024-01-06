

// convert unix timestamp to date
DateTime convertUnixTimeStampToDateString(int unixTimeStamp) {
  return DateTime.fromMillisecondsSinceEpoch(unixTimeStamp * 1000);
}

String getUploadTime(DateTime createdAt) {
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(createdAt);

  String uploadedTime;

  if (difference.inDays >= 7) {
    final int weeks = difference.inDays ~/ 7;
    if (weeks >= 4) {
      final int months = weeks ~/ 4;
      uploadedTime = '$months' 'm';
    } else {
      uploadedTime = '$weeks' 'w';
    }
  } else if (difference.inDays > 0) {
    uploadedTime = '${difference.inDays}' 'd';
  } else if (difference.inHours > 0) {
    uploadedTime = '${difference.inHours}' 'h';
  } else if (difference.inMinutes > 0) {
    uploadedTime = '${difference.inMinutes}' 'min';
  } else {
    uploadedTime = '${difference.inSeconds}' 's';
  }

  return uploadedTime;
}