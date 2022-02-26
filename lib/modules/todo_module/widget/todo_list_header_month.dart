import 'package:palette/common_components/common_components_link.dart';

class TodoListHeaderMonth extends StatelessWidget {
  final Function onPreviousIconTap;
  final Function onNextTap;
  final Function onTitleTap;
  final String title;
  const TodoListHeaderMonth(
      {Key? key,
      required this.onPreviousIconTap,
      required this.title,
      required this.onNextTap,
      required this.onTitleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            onPressed: () {
              onPreviousIconTap();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: defaultLight,
              size: 21.0,
            ),
          ),
          InkWell(
            onTap: () {
              onTitleTap();
            },
            child: Text(
              title,
              style: kalamLight.copyWith(
                  fontFamily: "MontserratMed", color: white, fontSize: 18),
            ),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              onPressed: () {
                onNextTap();
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: defaultLight,
                size: 21.0,
              )),
        ],
      ),
    );
  }
}
