library plus.pod_schema.balance_sheet;

import 'package:ebisu_pod/ebisu_pod.dart';

final package = new PodPackage('balance_sheet', namedTypes: [

  enum_('account_type', [
    'other',
    'roth_irs401k',
    'traditional_irs401k',
    'college_irs529',
    'traditional_ira',
    'investment',
    'brokerage',
    'checking',
    'health_savings_account',
    'savings',
    'money_market',
    'mattress',
  ])..doc = 'Various types of accounts',
  enum_('asset_type', [
    'other',
    'investment',
    'primary_residence',
    'family_property',
    'financial_instrument',
    'automobile',
    'life_insurance_policy',
    'company_stock_option',
    'savings',
    'college_savings',
    'retirement_savings',
    'cash',
    'rental_property',
  ]),
  enum_('liability_type',
      ['other', 'mortgage', 'auto_loan', 'college_debt', 'credit_card_debt',]),
  enum_('holding_type', ['other', 'stock', 'bond', 'cash', 'blend',])
    ..doc = 'Broad classification of a holding',
  enum_('interpolation_type', ['linear', 'step', 'cubic',]),
  enum_('payment_frequency', ['once', 'monthly', 'semiannual', 'annual',]),
  enum_('tax_category', [
    'labor_income',
    'interest_income',
    'qualified_dividend_income',
    'unqualified_dividend_income',
    'short_term_capital_gain',
    'long_term_capital_gain',
    'social_security_income',
    'pension_income',
    'other_ordinary_income',
    'inheritance',
    'rental_income',
    'property_value',
  ]),
  enum_('tax_type', [
    'ordinary_income',
    'qualified_dividend',
    'long_term_capital_gain',
    'short_term_capital_gain',
    'inheritance',
    'medicare',
    'social_security',
    'property',
  ]),
  enum_('taxing_authority', ['federal', 'state',]),
  object('date_value', [field('date', Date), field('value', Double)])
    ..doc = 'A value as of a specific date',
  object('date_range', [field('start', Date), field('end', Date)])
    ..doc = 'A range of dates - *[start, end)*',
  object('rate_curve', [field('curve_data', array('date_value')),])
    ..doc = 'A list of date value entries',
  object('capitalization_partition', [
    field('small_cap', Double),
    field('mid_cap', Double),
    field('large_cap', Double),
  ]),
  object('investment_style_partition', [
    field('value', Double),
    field('blend', Double),
    field('growth', Double),
  ]),
  object('allocation_partition', [
    field('stock', Double),
    field('bond', Double),
    field('cash', Double),
    field('other', Double),
  ]),
  object('instrument_partitions', [
    field('allocation_partition', 'allocation_partition'),
    field('investment_style_partition', 'investment_style_partition'),
    field('capitalization_partition', 'capitalization_partition'),
  ]),
  object('time_series', [field('data', array('date_value')),]),
  object('partition_mapping', [
    field('partitioned', Double),
    field('unpartitioned', Double),
    field('partition_map', strMap(Double)),
  ])
    ..doc = '''
Specifies a value that has been partitioned by the partition map
(i.e. percentages summing to 1.0), as well the value unpartitioned.  The
motivation is to allow aggregation of potentially unpartitioned values as well
as the paritioned values according to the percentages provided.
''',

  object('holding', [
    field('holding_type', 'holding_type'),
    field('quantity', 'date_value'),
    field('unit_value', 'date_value'),
    field('cost_basis', Double),
  ])
    ..doc = '''
The holding for a given symbol (or a sythetic aggregate as in an account other_holdings).

Both quantity and unitValue have dates associated with them. The marketValue of
the holding is based on the latest date of the two. This date can be different
(most likely older) than the date associated with the BalanceSheet owning the
holding.''',
  object('portfolio_account', [
    field('account_type', 'account_type'),
    field('descr'),
    field('owner'),
    field('holding_map', strMap('holding')),
    field('other_holdings', 'holding')
      ..doc = '''
Market value of all account holdings not specified in the holding map.

This gives the ability to enter an account with a market value and specific tax
treatment without having to fully specify all holdings individually.
''',
  ])
    ..doc = '''
The map of holdings indexed by symbol (or similar name unique to the portfolio).
''',
]);