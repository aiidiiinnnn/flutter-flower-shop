class ColorsViewModel{
  final int id;
  final int code;

  ColorsViewModel({
    required this.id,
    required this.code,
  });

  factory ColorsViewModel.fromJson(Map<String,dynamic> json){
    return ColorsViewModel(
      id: json["id"],
      code: json["code"],
    );
  }

  ColorsViewModel copyWith({
    int? id,
    int? code,
  })
  => ColorsViewModel(
    id: id ?? this.id,
    code: code ?? this.code,
  );

}