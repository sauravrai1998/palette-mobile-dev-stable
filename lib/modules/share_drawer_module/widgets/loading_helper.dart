import 'package:flutter/material.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/utils/konstants.dart';

class LoadingHelper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingHelper({Key? key, required this.isLoading, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: isLoading
                ? Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                          height: 100,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: purpleBlue.withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            content: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomPaletteLoader(),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Fetching link info....",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox())
      ],
    );
  }
}
