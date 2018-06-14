import XMonad
import XMonad.Config.Kde
import XMonad.Layout.Spacing

main = xmonad $ def
       { borderWidth        = 2
       , terminal           = "konsole"
       , normalBorderColor  = "#cccccc"
       , focusedBorderColor = "#cd8b00" }
