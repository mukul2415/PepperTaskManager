class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty.';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters long.';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description cannot be empty.';
    }
    return null;
  }

  static String? validateDueDate(DateTime? value) {
    if (value == null) {
      return 'Due date cannot be empty.';
    }
    if (value.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Due date cannot be in the past.';
    }
    return null;
  }
}