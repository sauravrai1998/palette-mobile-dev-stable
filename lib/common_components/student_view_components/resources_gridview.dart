import 'package:flutter/material.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/utils/konstants.dart';

class ResourcesGridView extends StatefulWidget {
  final double height;
  ResourcesGridView({required this.height});
  @override
  _ResourcesGridViewState createState() => _ResourcesGridViewState();
}

class _ResourcesGridViewState extends State<ResourcesGridView> {
  var data = [
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resources',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: defaultDark,
                      fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View All',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: defaultDark,
                            fontSize: 14),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 00),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 0,
                crossAxisCount: 2,
                mainAxisExtent: 110,
                crossAxisSpacing: 0,
              ),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                print(data[index]);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Imported.file_pdf,
                          size: 30,
                          color: defaultDark,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: defaultDark,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
