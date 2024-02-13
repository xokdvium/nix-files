{
  writeTextDir,
  coreutils,
}:
writeTextDir "widgets/time.yuck"
# yuck
''
  (defpoll current-time :interval "1s" "${coreutils}/bin/date '+%T'")
  (defpoll current-date :interval "1m" "${coreutils}/bin/date '+%D'")

  (defwidget widget-clock []
    (box :orientation "horizontal" :class "time"
      (box :orientation "horizontal"
        (label :text current-date)
        (label :text current-time))))
''
