import 'package:sample_pod/src/balance_sheet.dart' as balance_sheet;
import 'package:sample_pod/src/generate_library.dart';

main() {
  generateAngular(balance_sheet.package).generate();
}
