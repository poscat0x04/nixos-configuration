{ ... }:

{
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ''
      {-# LANGUAGE LambdaCase #-}
      {-# LANGUAGE TypeApplications #-}
      
      module Main where
      
      import Control.Concurrent
      import Data.List (isInfixOf)
      import Data.Map (Map)
      import Data.Ratio
      import Data.Semigroup (All)
      import XMonad
      import XMonad.Actions.CycleRecentWS
      import XMonad.Actions.CycleWindows
      import XMonad.Actions.UpdateFocus
      import XMonad.Config.Kde
      import XMonad.Hooks.EwmhDesktops
      import XMonad.Hooks.ManageDocks
      import XMonad.Hooks.ManageHelpers
      import XMonad.Hooks.SetWMName
      import XMonad.Layout.NoBorders
      import XMonad.Layout.Spacing
      import XMonad.Layout.TwoPane
      import XMonad.StackSet
        ( RationalRect (..),
          greedyView,
          shift,
          swapDown,
          swapUp,
        )
      import XMonad.Util.EZConfig
      import XMonad.Util.NamedScratchpad
      import XMonad.Util.Run
      import XMonad.Util.Scratchpad
      import XMonad.Util.SpawnOnce
      
      term :: String
      term = "konsole"
      
      normalBC :: String
      normalBC = "#778899"
      
      focusedBC :: String
      focusedBC = "#007FFF"
      
      modM :: KeyMask
      modM = mod4Mask
      
      bw :: Dimension
      bw = 3
      
      manageScratchPad :: ManageHook
      manageScratchPad =
        scratchpadManageHook (RationalRect 0 0 1 0.8)
      
      fullFloat :: ManageHook
      fullFloat = customFloating $ RationalRect 0 0.04 1 0.96
      
      scratchPads :: NamedScratchpads
      scratchPads =
        [ NS "telegram" "telegram-desktop" (className =? "TelegramDesktop") fullFloat,
          NS "keepassxc" "keepassxc" (className =? "KeePassXC") fullFloat,
          NS "anki" "anki" (className =? "Anki") fullFloat,
          NS "thunderbird" "thunderbird" (fmap ("Thunderbird" `isInfixOf`) (stringProperty "WM_ICON_NAME")) fullFloat,
          NS "discord" "Discord" (className =? "discord") fullFloat
        ]
      
      mHooks :: ManageHook
      mHooks =
        manageDocks
          <+> namedScratchpadManageHook scratchPads
          <+> manageScratchPad
          <+> composeOne
            [ stringProperty "WM_WINDOW_ROLE" =? "browser" -?> doShift "browser",
              stringProperty "WM_NAME" =? "Media viewer" -?> doCenterFloat,
              -- className =? "telegramdesktop" -?> doShift "im",
              className =? "krunner" -?> doIgnore >> doFloat,
              isKDETrayWindow -?> doIgnore >> doFloat,
              className =? "plasmashell" -?> doIgnore >> doFloat,
              title =? "Desktop — Plasma" -?> doIgnore,
              appName =? "xmessage" -?> doCenterFloat,
              stringProperty "WM_WINDOW_ROLE" =? "GtkFileChooserDialog" -?> floatCenteringWithRatio (2 % 3) (2 % 3),
              className =? "Vlc" -?> doCenterFloat,
              className =? "Mail" -?> doShift "media",
              className =? "Steam" -?> doCenterFloat,
              className =? "wpa_gui" -?> floatCenteringWithRatio (1 % 2) (1 % 2),
              appName =? "albert" -?> doCenterFloat,
              isFullscreen -?> doFullFloat,
              stringProperty "WM_NAME" =? "Open Folder" -?> doCenterFloat,
              stringProperty "WM_NAME" /=? "" -?> mempty,
              resource =? "desktop_window" -?> doIgnore,
              resource =? "kdesktop" -?> doIgnore
            ]
          <+> manageHook kde4Config
      
      floatCenteringWithRatio :: Rational -> Rational -> ManageHook
      floatCenteringWithRatio rx ry =
        doRectFloat $
          RationalRect (1 % 2 - rx / 2) (1 % 2 - ry / 2) rx ry
      
      ws :: [String]
      ws = ["term", "browser", "ide", "docs", "media"] ++ map @Int show [1 .. 3]
      
      xkeys :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
      xkeys = \c ->
        mkKeymap c $
          [ ("M-S-<Return>", spawn $ terminal c),
            -- Cycle between workspaces, emulates the alt-tab behavior of other DMs
            ("M1-<Tab>", cycleRecentWS [xK_Alt_L] xK_Tab xK_Tab),
            ("M-<Tab>", cycleRecentWindows [xK_Super_L] xK_Tab xK_Tab),
            ("M-S-q", spawn "dbus-send --print-reply --dest=org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout int32:1 int32:0 int32:1"),
            ("M-S-c", kill),
            ("M-<Space>", sendMessage NextLayout),
            ("M-S-<Space>", setLayout $ layoutHook c),
            ("M-S-j", windows swapDown),
            ("M-S-k", windows swapUp),
            -- Screenshot
            ("M-S-p", spawn "flameshot gui"),
            ("M-o", scratchpadSpawnActionTerminal "konsole"),
            ("M-t", namedScratchpadAction scratchPads "telegram"),
            ("M-i", namedScratchpadAction scratchPads "keepassxc"),
            ("M-m", namedScratchpadAction scratchPads "thunderbird"),
            ("M-j", namedScratchpadAction scratchPads "discord")
          ]
            <> [ (otherModMasks <> "M-" <> show i, action w)
                 | (w, i) <- zip @_ @Int (workspaces c) [1 .. 9],
                   (otherModMasks, action) <-
                     [ ("", windows . greedyView),
                       ("S-", windows . shift)
                     ]
               ]
      
      lHooks =
        spacingRaw True (Border 0 0 6 6) True (Border 0 0 6 6) True
          $ avoidStruts
          $ TwoPane delta ratio
            ||| noBorders Full
        where
          delta = 0.03
          ratio = 0.5
      
      sHooks :: X ()
      sHooks =
        composeAll
          [ spawnOnce "krunner -d",
            setWMName "LG3D",
            liftIO (threadDelay (seconds 5)) >> spawnOnce "wpa_gui -t",
            namedScratchpadAction scratchPads "keepassxc",
            namedScratchpadAction scratchPads "telegram",
            namedScratchpadAction scratchPads "thunderbird"
          ]
      
      hHooks :: Event -> X All
      hHooks =
        fullscreenEventHook
          <+> focusOnMouseMove
          <+> docksEventHook
          <+> handleEventHook kde4Config
      
      main :: IO ()
      main =
        xmonad $
          ewmh
            def
              { terminal = term,
                normalBorderColor = normalBC,
                modMask = modM,
                focusedBorderColor = focusedBC,
                manageHook = mHooks,
                workspaces = ws,
                borderWidth = bw,
                keys = xkeys,
                layoutHook = lHooks,
                startupHook = sHooks,
                handleEventHook = hHooks
              }
    '';
  };
}
