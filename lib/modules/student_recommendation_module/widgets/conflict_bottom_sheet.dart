import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class ConflictBottomSheet extends StatefulWidget {
  ConflictBottomSheet({Key? key}) : super(key: key);

  @override
  _ConflictBottomSheetState createState() => _ConflictBottomSheetState();
}

class _ConflictBottomSheetState extends State<ConflictBottomSheet> {
  var _conflictTextController = TextEditingController();
  var _conflictTextFocusNode = FocusNode();
  bool _isConflictTextFocused = false;

  @override
  Widget build(BuildContext context) {
    double _screenHeight = _isConflictTextFocused
        ? MediaQuery.of(context).size.height * 0.9
        : MediaQuery.of(context).size.height * 0.62;
    return Container(
      height: _screenHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: _screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    SvgPicture.asset('images/paletteimage.svg',
                        height: 130, width: 120),
                    const SizedBox(width: 16),
                    Text('Oh no!',
                        style: robotoTextStyle.copyWith(
                            fontSize: 30, fontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    'Please let us know what issues you have regarding the consideration.',
                    style: robotoTextStyle.copyWith(fontSize: 20)),
                const SizedBox(height: 16),
                Text(
                    'We will pass it on to the creator. They will review and make changes if possible',
                    style: robotoTextStyle.copyWith(
                        fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 16),
                Container(
                  height: 150,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Describe your concern...',
                      hintStyle: robotoTextStyle.copyWith(
                          fontSize: 16, color: Colors.grey),
                    ),
                    controller: _conflictTextController,
                    focusNode: _conflictTextFocusNode,
                    onTap: () {
                      setState(() => _isConflictTextFocused = true);
                    },
                    onSubmitted: (value) {
                      setState(() => _isConflictTextFocused = false);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'CANCEL',
                          style: roboto700.copyWith(
                            color: pinkRed,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        color: defaultDark,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'SUBMIT',
                          style: roboto700.copyWith(
                            color: white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
