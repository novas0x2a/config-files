import XMonad hiding (mouseResizeWindow, appName)
import XMonad.Actions.CycleWS               (nextWS, prevWS, shiftToNext, shiftToPrev, moveTo, toggleWS, nextScreen, shiftNextScreen, shiftTo, WSType(..), Direction1D(..), toggleOrDoSkip)
import XMonad.Prompt
import Data.IORef

import Data.Char
import Control.Applicative                  ((<$>))
import Control.Arrow                        ((&&&), (***))
import Control.Monad                        (join, liftM)
import Data.List                            (isPrefixOf, isInfixOf, isSuffixOf, partition)
import Data.Map                             (Map(..), union, fromList)
import Data.Maybe                           (fromMaybe)
import Data.Ratio                           ((%))
import System.Cmd                           (system)
import System.Exit                          (exitWith, ExitCode(..))
import System.FilePath.Posix                (takeBaseName)
import XMonad.Actions.CycleRecentWS         (cycleRecentWS)
import XMonad.Actions.FindEmptyWorkspace    (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Actions.FlexibleResize        (mouseResizeWindow)
import XMonad.Actions.Warp                  (warpToWindow)
import XMonad.Actions.WindowGo              (raiseNext, runOrRaise, runOrRaiseNext, raiseMaybe, raiseNextMaybe)
import XMonad.Config.Desktop                (desktopConfig)
import XMonad.Hooks.ManageDocks             (manageDocks, avoidStruts, docksEventHook, docksStartupHook)
import XMonad.Hooks.ManageHelpers           (doCenterFloat, isFullscreen, (-?>),  doFullFloat, isDialog)
import XMonad.Hooks.SetWMName               (setWMName)
import XMonad.Hooks.EwmhDesktops            (fullscreenEventHook)
import XMonad.Layout.HintedGrid             (Grid(..))
import XMonad.Layout.LayoutHints            (layoutHintsToCenter)
import XMonad.Layout.NoBorders              (smartBorders)
import XMonad.Layout.PerWorkspace           (onWorkspace)
import XMonad.Layout.Tabbed                 (simpleTabbed)
import XMonad.ManageHook                    (appName)
import XMonad.Prompt.Man                    (manPrompt)
import XMonad.Prompt.Shell                  (shellPrompt)
import XMonad.Prompt.Ssh                    (sshPrompt)
import XMonad.Prompt.Window                 (windowPromptBring, windowPromptGoto)
import XMonad.Prompt.XMonad                 (xmonadPrompt)
import XMonad.Util.EZConfig                 (mkKeymap)
import XMonad.Util.Run                      (spawnPipe, hPutStrLn, safeSpawn, unsafeSpawn)

import qualified XMonad.Actions.Search      as S
import qualified XMonad.Layout.IM           as IM
import qualified XMonad.StackSet            as W
import qualified XMonad.Layout.HintedTile   as HT


isPrefixOfQ :: String -> Query String -> Query Bool
isPrefixOfQ = fmap . isPrefixOf

isInfixOfQ :: String -> Query String -> Query Bool
isInfixOfQ  = fmap . isInfixOf

isSuffixOfQ :: String -> Query String -> Query Bool
isSuffixOfQ  = fmap . isSuffixOf

toUpperQ :: Query String -> Query String
toUpperQ = fmap $ map toUpper

iEq :: Query String -> String -> Query Bool
iEq q x = toUpperQ q =? (map toUpper x)

chrome :: String
chrome = "google-chrome-beta"


elemQ :: (Eq a, Functor f) => a -> f [a] -> f Bool
elemQ = fmap . elem

pApp   = appName
pClass = className
pName  = stringProperty "WM_NAME"
pRole  = stringProperty "WM_WINDOW_ROLE"

replicateMessage n m = foldr1 (>>) $ replicate n $ sendMessage m

rrArgs :: FilePath -> [String] -> Query Bool -> X ()
rrArgs = (raiseMaybe .) . safeSpawn

rr = runOrRaise

rrN = raiseNextMaybe . unsafeSpawn

gvimFile :: FilePath -> X ()
gvimFile file = rrArgs "gvim" ["--class=please-float-me", "-geom 150x55+20+0", file]
                                $ pClass =? "please-float-me" <&&> (takeBaseName file) `isInfixOfQ` pName

myKeys :: IORef Integer -> XConfig Layout -> Map (KeyMask, KeySym) (X ())
myKeys floatNextWindows conf = mkKeymap conf $
    -- WM Manipulation Commands
    [ ("M-q",           restart "xmonad" True               ) -- restart xmonad
    -- , ("M-S-q",         io (exitWith ExitSuccess)           ) -- quit
    -- , ("M-S-q",         spawn "gnome-session-save --gui --logout" ) -- quit
    , ("M-S-q",         spawn "xfce4-session-logout" ) -- quit
    , ("M-S-c",         kill                                ) -- close focused window
    , ("M-f",           io (modifyIORef floatNextWindows succ) >> logHook conf)
    , ("M-C-f",         io (modifyIORef floatNextWindows (const 500)) >> logHook conf)
    , ("M-S-f",         io (modifyIORef floatNextWindows (const 0))   >> logHook conf)

    -- Within A Workspace
    , ("M-<Space>",     sendMessage NextLayout              ) -- Rotate through layouts
    , ("M-S-<Space>",   setLayout $ layoutHook conf         ) -- Set layout list to default
    , ("M-n",           refresh                             ) -- Reapply current layout
    , ("M-j",           windows W.focusDown                 ) -- Focus next window
    , ("M-k",           windows W.focusUp                   ) -- Focus previous window
    , ("M-m",           windows W.focusMaster               ) -- Focus master window
    , ("M-<Return>",    windows W.swapMaster                ) -- Swap focused <=> master
    , ("M-S-j",         windows W.swapDown                  ) -- Swap focused <=> next
    , ("M-S-k",         windows W.swapUp                    ) -- Swap focused <=> previous
    , ("M-h",           replicateMessage 3 Shrink           ) -- Shrink master
    , ("M-S-h",         sendMessage Shrink                  ) -- Shrink master
    , ("M-l",           replicateMessage 3 Expand           ) -- Expand master
    , ("M-S-l",         sendMessage Expand                  ) -- Expand master
    , ("M-t",           withFocused $ windows . W.sink      ) -- Demote window
    , ("M-,",           sendMessage (IncMasterN 1)          ) -- master_count++
    , ("M-.",           sendMessage (IncMasterN (-1))       ) -- master_count--

    -- Between Workspaces
    , ("M-<U>",         moveTo  Next EmptyWS                ) -- go to empty
    , ("M-<D>",         moveTo  Next EmptyWS                ) -- go to empty
    , ("M-S-<U>",       shiftTo Next EmptyWS                ) -- Push current window away
    , ("M-S-<D>",       tagToEmptyWorkspace                 ) -- Take current window with me
    , ("M-<R>",         moveTo Next HiddenNonEmptyWS        ) -- go to next non-empty
    , ("M-<L>",         moveTo Prev HiddenNonEmptyWS        ) -- go to prev non-empty
    , ("M-z",           toggleWS                            ) -- go to last workspace
    , ("M-S-<R>",       shiftToNext >> nextWS               ) -- Move window to next
    , ("M-S-<L>",       shiftToPrev >> prevWS               ) -- Move window to prev
    , ("M-w",           nextScreen >> mouseFollow           ) -- Move focus to next screen
    , ("M-S-w",         shiftNextScreen >> mouseFollow      ) -- Move window to next screen

    -- Search Prompts
    , ("M-/",           shellPrompt xpc                     ) -- Shell
    , ("M-;",           windowPromptGoto  xpcSub            ) -- Window
    , ("M-S-;",         windowPromptBring xpcSub            ) -- Window
    , ("M-p s",         sshPrompt xpc                       ) -- SSH
        , ("M-p m",     manPrompt xpcAuto                   ) -- Man
    , ("M-d g",         searchSite S.google                 ) -- Google
        , ("M-d h",     searchSite S.hoogle                 ) -- Hoogle
        , ("M-d a",     searchSite S.amazon                 ) -- Amazon
        , ("M-d i",     searchSite S.imdb                   ) -- IMDB
        , ("M-d w",     searchSite S.wikipedia              ) -- Wikipedia

    -- Raise/Spawn Things
    , ("M-'",           spawn $ terminal conf               ) -- Terminal
    , ("M-`",           raiseNext $ pClass =? "Pidgin"      ) -- Focus pidgin conv window
    , ("M-<Tab>",       raiseNext $ "slack" `isInfixOfQ` pApp ) -- Focus slack conv window
    , ("M-S-d",         spawn "write-all-props"             )

    , ("M-s m",         rrArgs chrome ["--app=https://mail.google.com"]                   $ pApp =? "mail.google.com")
        , ("M-s S-m",   rrArgs chrome ["--app=https://mail.google.com/mail/u/1"]          $ pApp =? "mail.google.com__mail_u_1")
        , ("M-s c",     rrArgs chrome ["--app=https://calendar.google.com"]                $ pApp =? "calendar.google.com")
        , ("M-s S-c",   rrArgs chrome ["--app=https://calendar.google.com/a/mulesoft.com"] $ pApp =? "calendar.google.com__a_mulesoft.com")
        , ("M-s p",     rrArgs "keepassxc" ["/home/mike/Dropbox/pw/Personal.kdbx"] $ pClass =? "Personal.kdb")
        , ("M-s b",     rrArgs "thunar" ["~/"]                                    $ pClass =? "Thunar")
        , ("M-s S-b",   spawn "thunar ~/")
        , ("M-s f",     rrN chrome $ pRole =? "browser")
        --, ("M-s f",     rrN chrome
        --                    $ ((pClass =? "Firefox" <&&> pRole =? "browser")
        --                    <||> (pClass =? "Epiphany")
        --                    <||> ("- Chromium" `isSuffixOfQ` pName)))
        , ("M-s d",     spawn chrome)
        , ("M-s S-d",   spawn "chromium --incognito")
        --, ("M-s g",     spawn "firefox -P default" )
        --, ("M-s i",     spawn "firefox -P testing -no-remote" )
        --, ("M-s t",     gvimFile "/media/disk/Dropbox/TODO.otl")
        , ("M-s l",     spawn "xscreensaver-command -l"  )
    , ("M-e",           spawn "gvim $HOME/.xmonad/xmonad.hs")
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (workspaces conf) $ map show $ [1..9] ++ [0]
        , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]]
    -- ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    --[("M-" ++ m ++ key, screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip ["w", "e", "r"] [0..]
    --    , (f, m) <- [(W.view, ""), (W.shift, "S-")]]
        where
            searchSite  = S.promptSearchBrowser xpc chrome
            mouseFollow = warpToWindow (1%4) (1%4)
            xpcAuto     = xpc {autoComplete = Just 500000}
            xpcSub      = xpc {autoComplete = Just 100000, searchPredicate = isInfixOf}
            xpc         = defaultXPConfig { font     = "xft:DejaVu Sans-8"
                                          , bgColor  = "black"
                                          , fgColor  = "grey"
                                          , promptBorderWidth = 1
                                          , position = Bottom
                                          , height   = 30
                                          , historySize = 256 }

--myKeys2 conf = fromList $
--    [ ((0, 0x1008ff11), spawn "pactl -- set-sink-volume 1 '-5%'") -- vol--
--    , ((0, 0x1008ff13), spawn "pactl -- set-sink-volume 1 '+5%'") -- vol++
--    , ((0, 0x1008ff12), spawn "amixer -q sset Master toggle") -- mute
--    ]

myMouseBindings (XConfig {modMask = modMask}) = fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))    -- mod-button1, Set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster)) -- mod-button2, Raise the window to the top of the stack , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))  -- mod-button3, Set the window to floating mode and resize by dragging -- you may also bind events to the mouse scroll wheel (button4 and button5)
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]


------------------------------------------------------------------------
-- Layouts:

myLayout = avoidStruts . layoutHintsToCenter . smartBorders
         $ onWorkspace "14:chat"   (IM.withIM (1%10) isPidgin $ Mirror $ hint HT.Tall)
         $ hint HT.Tall ||| Grid False ||| simpleTabbed
    where
        hint     = HT.HintedTile 1 (3%100) (3%5) HT.TopLeft
        isPidgin = IM.And (IM.ClassName "Pidgin") (IM.Role "buddy_list")

------------------------------------------------------------------------
myManageHook :: IORef Integer -> ManageHook
myManageHook floatNextWindows = composeAll $ concat
    [[ manageDocks ]
    ,[ isFullscreen                                   --> doFullFloat   ]
    ,[ isDialog                                       --> doCenterFloat ]
    ,[ ((pClass `iEq` klass) <&&> (pName `iEq` name)) --> doCenterFloat | (klass, name) <- floatByClassName]
    ,[ pClass `iEq` klass                             --> doCenterFloat | klass <- floatByClass]
    ,[ pClass `iEq` klass                             --> doIgnore | klass <- ignoreByClass ]
    ,[ pName  `iEq` name                              --> doCenterFloat | name  <- floatByName]
    ,[ pClass `iEq` name <||> (pApp `iEq` name)       --> doF (W.shift workspace) | (name, workspace) <- shifts ]
    ,[ (> 0) `liftM` io (readIORef floatNextWindows)
                                    --> do io (modifyIORef floatNextWindows pred) >> doCenterFloat ]
    ]
    where
        ignoreByClass    = ["stalonetray", "trayer"]
        floatByName      = ["please-float-me", "Steam", "glxgears"]
        floatByClass     = ["MPlayer", "please-float-me", "sun-awt-X11-XFramePeer", "Atasjni", "Wine", "Cssh", "zoom", "orage", "keepassx", "KeePassXC"]
        floatByClassName = []
        shifts = ("web.ciscospark.com", "13:work")
               : ("ciscocf.slack.com", "13:work")
               : ("mulesoft.slack.com", "13:work")
               : ("metacloud.hipchat.com__chat", "13:work")
               : ("Pidgin","14:chat")
               : ("Skype","14:chat")
               : []


--myWorkspaces = ["α","β","γ","δ","ε","ζ","η","θ","ι","κ","λ","μ","ν","ξ","ο","π","ρ","σ","τ","υ","φ","χ","ψ","ω"]

prependNum :: (Show a) => String -> a -> String
prependNum str num = (show num) ++ ":" ++ str

makeWorkspaces :: Int -> [String] -> [String]
makeWorkspaces total namedWorkspaces =
    uncurry (++)
    . (map show *** zipWith prependNum namedWorkspaces)
    $ partition (<= total - (length namedWorkspaces)) [1..total]


--makeWorkspaces 10 ["alpha", "bravo"] ->
--["1", "2", "3", "4", "5", "6", "7", "8", "9:alpha", "10:bravo"]

myTerminal = "run-xterm.sh"

main = do
    --xmobar           <- spawnPipe "xmobar"
    floatNextWindows <- newIORef 0
    xmonad $ desktopConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        borderWidth        = 2,
        modMask            = mod4Mask,
        workspaces         = makeWorkspaces 14 ["work", "chat"],
        normalBorderColor  = "#FF0000",
        focusedBorderColor = "#00FF00",

      -- key bindings
        --keys               = \c -> myKeys floatNextWindows c `union` myKeys2 c,
        keys               = myKeys floatNextWindows <+> keys desktopConfig,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook floatNextWindows,
        --- Normal EWMH hook doesn't include support for _NET_WM_STATE_FULLSCREEN. Add this.
        handleEventHook    = handleEventHook desktopConfig <+> docksEventHook <+> fullscreenEventHook,
        startupHook        = startupHook desktopConfig <+> setWMName "LG3D" <+> docksStartupHook
    }
