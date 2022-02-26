import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class NameAndRoleViwer extends StatelessWidget {
  const NameAndRoleViwer({
    Key? key,
    required this.name,
    required this.role,
  }) : super(key: key);
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                name,
                style:
                    montserratNormal.copyWith(fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Container(
                child: Text(
                  role,
                  style: montserratNormal.copyWith(
                      fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
