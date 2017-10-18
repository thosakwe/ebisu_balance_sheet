library balance_sheet.components.balance_sheet_application;

import 'package:angular2/angular2.dart';

// custom <additional imports>
// end <additional imports>

@RouteConfig(const [
  const Route(
    name: "Detail",
    path: "/detail/:id",
    component: PortfolioAccountDetailComponent,
  )
  const Route(
    name: "List",
    path: "/list",
    component: PortfolioAccountListComponent,
  )
])
@Component (
selector: 'balance-sheet-application',
templateUrl: "balance_sheet_application.html"
)
class BalanceSheetApplication {

  // custom <class BalanceSheetApplication>
  // end <class BalanceSheetApplication>

}


class PortfolioAccount {

  AccountType accountType
  ;
  Str descr
  ;
  Str owner
  ;
  MapOfStrToHolding holdingMap
  ;
  Holding otherHoldings
  ;

  // custom <class PortfolioAccount>
  // end <class PortfolioAccount>

}

  // custom <library balance_sheet_application>
  // end <library balance_sheet_application>


