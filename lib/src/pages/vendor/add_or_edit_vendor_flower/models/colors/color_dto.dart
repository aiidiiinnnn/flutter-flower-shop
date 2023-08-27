class ColorsDto{
  final int code;

  ColorsDto({
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    "code": code,
  };

}