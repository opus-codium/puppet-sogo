# @summary Describe SOGo junk mail settings
type Sogo::Mail_junk_settings = Struct[
  vendor              => Enum['generic'],
  junkEmailAddress    => String[1],
  notJunkEmailAddress => String[1],
  limit               => Integer[0],
]
