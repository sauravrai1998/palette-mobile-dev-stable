import 'package:palette/common_components/common_components_link.dart';

class CalendarFormatButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final void Function() onTap;
  const CalendarFormatButton(
      {Key? key,
      required this.isSelected,
      required this.title,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 600),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.08))
              ],
              color: isSelected ? kDarkGrayColor : defaultLight),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: "MontserratReg",
                  fontWeight: FontWeight.w700,
                  color: !isSelected ? kDarkGrayColor : Colors.white,
                  fontSize: 12),
            ),
          ),
        ),
      ),
      style:
          TextStyle(fontFamily: "MontserratReg", fontWeight: FontWeight.w700),
    );
  }
}
