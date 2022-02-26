import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/utils/konstants.dart';

class SearchForFiles extends StatefulWidget {
  @override
  _SearchForFilesState createState() => _SearchForFilesState();
}

class _SearchForFilesState extends State<SearchForFiles> {
  var indexSelected = -1;

  var data = [
    'FileName',
    'FileName',
    'Amardeep',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName',
    'FileName'
  ];

  var displayData = [];
  var searchedText;

  setData() {
    displayData = [];
    if (searchedText == null || searchedText.length == 0) {
      displayData = data;
    } else {
      displayData =
          data.where((element) => element.contains(searchedText)).toList();
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          indexSelected == -1
              ? Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 20, top: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: defaultDark,
                            size: 27,
                          )),
                    ],
                  ),
                )
              : Container(
                  height: 50,
                  color: defaultDark,
                  padding: EdgeInsets.only(left: 20, top: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              indexSelected = -1;
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 27,
                          )),
                      Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexSelected = -1;
                                  });
                                },
                                child: Icon(
                                  Icons.remove_red_eye,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexSelected = -1;
                                  });
                                },
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 27,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    indexSelected = -1;
                                  });
                                },
                                child: Icon(
                                  Icons.download_sharp,
                                  color: Colors.white,
                                  size: 27,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: Offset(0, 0),
                          spreadRadius: 0.25)
                    ]),
                child: TextFormField(
                  onChanged: (value) {
                    searchedText = value;
                    setData();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search files",
                      contentPadding: EdgeInsets.only(left: 15)),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 32),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 30,
              crossAxisCount: 2,
              mainAxisExtent: 110,
              crossAxisSpacing: 30,
            ),
            itemCount: displayData.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (indexSelected == index) {
                        indexSelected = -1;
                      } else {
                        indexSelected = index;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          indexSelected == index ? defaultDark : Colors.white,
                      borderRadius: BorderRadius.circular(7),
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
                          size: 35,
                          color: indexSelected != index
                              ? defaultDark
                              : Colors.white,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          data[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: indexSelected != index
                                ? defaultDark
                                : Colors.white,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
