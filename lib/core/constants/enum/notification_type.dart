enum NotificationType {
  normal(0),
  verificationCode(1);

  final int value;
  const NotificationType(this.value);

  static NotificationType fromInt(int s) => switch (s) {
    1 => verificationCode,
    0 => normal,
    _ => normal,
  };
}