import 'dart:developer';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:palette/modules/share_drawer_module/model/link_meta_info.dart';

class CommonLinkMetaInfo {
  Future<LinkMetaInfo?> getMetaInfoOfLink({required String url}) async {
    LinkMetaInfo result = LinkMetaInfo();
    try {
      var response = await get(Uri.parse(url));
      log("Response of uri is:${response.statusCode}");
      if (response.statusCode == 200) {
        var document = parse(response.body);

        return _extractOGData(document);
      } else {
        var metaInfo = await MetadataFetch.extract(url);
        log("Meta-Info about link is:");
        if (metaInfo != null) {
          metaInfo.toJson().forEach((key, value) {
            log("$key: $value");
          });
        }
        result = LinkMetaInfo(
            title: metaInfo?.title, description: metaInfo?.description);
        return result;
      }
    } catch (e) {
      log("Error in getting MetaInfo:$e");
      return null;
    }
  }

  LinkMetaInfo? _extractOGData(
    Document document,
  ) {
    log("Parsed:${HtmlMetaParser(document).parse()}");
    var htmlMetaParser = HtmlMetaParser(document).parse();
    List<Element> elementList = document.getElementsByTagName('meta');
    String? description;
    elementList.forEach((element) {
      if (element.attributes['name'] == "description") {
        description = element.attributes['content'];
      }
      //log("Link Data is:${element.attributes}}");
    });
    LinkMetaInfo result = LinkMetaInfo(
        title: htmlMetaParser.title,
        description: htmlMetaParser.description ?? description);
    return result;
  }
}
