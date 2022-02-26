import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';

class BackNavAppBar extends StatefulWidget {
  final String title;

  BackNavAppBar({required this.title});

  @override
  _BackNavAppBarState createState() => _BackNavAppBarState();
}

class _BackNavAppBarState extends State<BackNavAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Semantics(
        button: true,
        onTapHint: "Navigated back",
        child: IconButton(
            icon: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset('images/dropdown.svg')),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      title: Semantics(
        label: widget.title,
        child: Text(
          widget.title,
          style: kalam700,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
