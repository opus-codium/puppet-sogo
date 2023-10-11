# @summary Available values for refreshing views
type Sogo::Refresh_view_check = Enum[
  'manually',
  'every_minute',
  'every_2_minutes',
  'every_5_minutes',
  'every_10_minutes',
  'every_20_minutes',
  'every_30_minutes',
  'once_per_hour',
]
