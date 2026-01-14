String getTimeAgo(String postTime) {
  DateTime postDate =
      DateTime.parse(postTime); // Convert the post time to a DateTime
  Duration diff = DateTime.now().difference(postDate); // Get the difference

  if (diff.inDays >= 30) {
    int months = (diff.inDays / 30).floor(); // Convert days to months
    return months.toString() + "M ago"; // 'M' for months
  } else if (diff.inDays > 0) {
    return "${diff.inDays}" + "D ago"; // 'D' for days
  } else if (diff.inHours > 0) {
    return "${diff.inHours} H ago"; // 'H' for hours
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes} M ago"; // 'M' for minutes
  } else {
    return "few seconds ago";
  }
}
