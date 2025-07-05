class FormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
    }
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون على الأقل 8 أحرف';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
        .hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على أحرف كبيرة وصغيرة وأرقام';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != password) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    final name = fieldName ?? 'الحقل';
    if (value == null || value.isEmpty) {
      return 'إدخال $name';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال اسم المستخدم';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }

    return null;
  }

  static String? validateCaseType(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى اختيار نوع القضية';
    }
    return null;
  }

  static String? validateCaseDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال وصف القضية';
    }
    return null;
  }

  static String? validateNumeric(String? value, {bool required = false}) {
    if (required && (value == null || value.isEmpty)) {
      return 'يرجى إدخال قيمة';
    }
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'يرجى إدخال أرقام فقط';
      }
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال المدينة';
    }
    return null;
  }

  static String? validatePlaintiffName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال اسم المدعي';
    }
    return null;
  }

  static String? validateDefendantName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال اسم المدعي عليه';
    }
    return null;
  }
}
