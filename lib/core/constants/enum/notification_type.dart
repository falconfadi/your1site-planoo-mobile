enum NotificationType {
  normal(0),
  verificationCode(1),
  activity(2),
  course(3),
  event(4),
  appointment(5),
  session(6),
  chat(10);

  final int value;
  const NotificationType(this.value);

  static NotificationType fromInt(int s) => switch (s) {
    1 => verificationCode,
    2 => activity,
    3 => course,
    4 => event,
    5 => appointment,
    6 => session,
    10 => chat,
    0 => normal,
    _ => normal,
  };
}