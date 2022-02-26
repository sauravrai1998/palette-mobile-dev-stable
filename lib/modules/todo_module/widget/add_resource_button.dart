import 'package:palette/common_components/common_components_link.dart';

class AddResourceButton extends StatelessWidget {
  const AddResourceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: defaultDark,
            size: 22,
          ),
          Text(
            'Resource',
            style: robotoTextStyle.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
