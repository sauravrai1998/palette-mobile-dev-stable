import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class TicketsPageForAdmin extends StatefulWidget {
  @override
  _TicketsPageForAdminState createState() => _TicketsPageForAdminState();
}

class _TicketsPageForAdminState extends State<TicketsPageForAdmin> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'images/admin_small_splash.svg',
              height: 130,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'Palette',
                  style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
                ),
                leading: IconButton(
                  color: Colors.transparent,
                  icon: Icon(Icons.backspace_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(child: Center(child: Text("Tickets Page")))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
