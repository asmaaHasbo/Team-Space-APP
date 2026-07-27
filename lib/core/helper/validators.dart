

String? validatePassportNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'signup.validation.required';
  }
  if (value.trim().length < 6) return 'signup.validation.passportMin6';
  return null;
}

String? validateNationalNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'signup.validation.required';
  }
  if (!RegExp(r'^\d{12}$').hasMatch(value.trim())) {
    return 'signup.validation.nationalNumber12';
  }
  return null;
}

String? validateSignupPassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'signup.validation.required';
  }
  final v = value.trim();
  if (v.length < 8) return 'signup.validation.passwordRule';
  if (!RegExp(r'[A-Z]').hasMatch(v)) return 'signup.validation.passwordRule';
  if (!RegExp(r'[a-z]').hasMatch(v)) return 'signup.validation.passwordRule';
  if (!RegExp(r'[0-9]').hasMatch(v)) return 'signup.validation.passwordRule';
  return null;
}

String? Function(String?) validateConfirmPassword(String? Function() getPassword) {
  return (String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'signup.validation.required';
    }
    if (value.trim() != getPassword()?.trim()) {
      return 'signup.validation.passwordsDoNotMatch';
    }
    return null;
  };
}

String? validateRequired(String? value) {
  if (value == null || value.trim().isEmpty) return 'signup.validation.required';
  return null;
}


String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }

  // Regex pattern for email validation as per requirements
  final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email';
  }

  return null; // Valid
}

/// Validates password format and length

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required';
  }

  final trimmedValue = value.trim();

  if (trimmedValue.length < 6) {
    return 'Password must be at least 6 characters';
  }

  if (trimmedValue.length > 128) {
    return 'Password must not exceed 128 characters';
  }

  return null; // Valid
}
