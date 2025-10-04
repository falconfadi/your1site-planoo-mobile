
enum SessionDurationEnum {
  minutes30(30),
  minutes60(60),
  minutes90(90),
  minutes120(120);

  final int value;
  const SessionDurationEnum(this.value);

  static SessionDurationEnum fromInt(int v) => switch (v) {
    30 => SessionDurationEnum.minutes30,
    60 => SessionDurationEnum.minutes60,
    90 => SessionDurationEnum.minutes90,
    120 => SessionDurationEnum.minutes120,
    _ => SessionDurationEnum.minutes30,
  };
}