# @summary Available roles for calendars
type Sogo::Calendar_role = Enum[
  'PublicViewer',
  'PublicDAndTViewer',
  'PublicModifier',
  'PublicResponder',
  'ConfidentialViewer',
  'ConfidentialDAndTViewer',
  'ConfidentialModifier',
  'ConfidentialResponder',
  'PrivateViewer',
  'PrivateDAndTViewer',
  'PrivateModifier',
  'PrivateResponder',
  'ObjectCreator',
  'ObjectEraser',
]
