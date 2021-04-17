import 'package:intl/intl.dart';

class PriceUtils {
  static final oCcy = new NumberFormat("#,###", "ko_KR");
  static String calcStringToWon(String priceString) {
    if (priceString != null && priceString != "") {
      return "${oCcy.format(int.parse(priceString))} 원";
    } else {
      return "- 원";
    }
  }
}
