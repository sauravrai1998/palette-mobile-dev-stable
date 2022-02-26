import 'package:palette/modules/todo_module/models/ward.dart';

class Asignee {
  Ward ward;
  bool isSelected;
  Asignee({required this.ward, this.isSelected = false});

  Asignee copyWith({
    Ward? ward,
    bool? isSelected,
  }) {
    return Asignee(
      ward: ward ?? this.ward,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
