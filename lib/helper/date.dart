String getDateFormatted(String? createdAt) {
  DateTime date = DateTime.parse(createdAt!);
  return "${date.year}-${date.month}-${date.day}";
}
