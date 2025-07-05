enum UserRole {
  client,
  lawyer,
  judge;

  String getArabicName() {
    switch (this) {
      case UserRole.client:
        return 'عميل';
      case UserRole.lawyer:
        return 'محامي';
      case UserRole.judge:
        return 'قاضي';
    }
  }
}
