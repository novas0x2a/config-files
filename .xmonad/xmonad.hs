import XMonad hiding (mouseResizeWindow)
import XMonad.Actions.CycleWS
import XMonad.Prompt
import Data.IORef

import Control.Applicative                  ((<$>))
import Control.Arrow                        ((&&&))
import Control.Monad                        (liftM)
import Data.List                            (isPrefixOf, isInfixOf)
import Data.Map                             (Map(..), union, fromList)
import Data.Maybe                           (fromMaybe)
import Data.Ratio                           ((%))
import System.Cmd                           (system)
import System.Exit                          (exitWith, ExitCode(..))
import XMonad.Actions.CycleRecentWS         (cycleRecentWS)
import XMonad.Actions.FindEmptyWorkspace    (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Actions.FlexibleResize        (mouseResizeWindow)
import XMonad.Actions.Warp                  (warpToWindow)
import XMonad.Actions.WindowGo              (raise, runOrRaise)
import XMonad.Hooks.DynamicLog              (dynamicLogWithPP, xmobarPP, ppOutput, ppUrgent, ppTitle, ppExtras, xmobarColor)
import XMonad.Hooks.ManageDocks             (manageDocks, avoidStruts, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers           (doCenterFloat)
import XMonad.Hooks.SetWMName               (setWMName)
import XMonad.Layout.LayoutHints            (layoutHints)
import XMonad.Layout.NoBorders              (smartBorders)
import XMonad.Layout.PerWorkspace           (onWorkspace)
import XMonad.Layout.Spiral                 (spiralWithDir)
import XMonad.Prompt.Man                    (manPrompt)
import XMonad.Prompt.Shell                  (shellPrompt)
import XMonad.Prompt.Ssh                    (sshPrompt)
import XMonad.Prompt.Window                 (windowPromptBring, windowPromptGoto)
import XMonad.Prompt.XMonad                 (xmonadPrompt)
import XMonad.Util.EZConfig                 (mkKeymap)
import XMonad.Util.Run                      (spawnPipe, hPutStrLn)
import XMonad.Util.WorkspaceCompare         (getSortByIndex)

import qualified System.IO.UTF8             as UTF8
import qualified XMonad.Actions.Search      as S
import qualified XMonad.Layout.IM           as IM
import qualified XMonad.Layout.Spiral       as Spiral
import qualified XMonad.StackSet            as W

isPrefixOfQ = fmap . isPrefixOf

isInfixOfQ :: String -> Query String -> Query Bool
isInfixOfQ  = fmap . isInfixOf

elemQ = fmap . elem

--pName  = appName
pClass = className
pName  = stringProperty "WM_NAME"
--pClass = stringProperty "WM_CLASS"
pRole  = stringProperty "WM_WINDOW_ROLE"


myKeys :: IORef Integer -> XConfig Layout -> Map (KeyMask, KeySym) (X ())
myKeys floatNextWindows conf = mkKeymap conf $
    -- WM Manipulation Commands
    [ ("M-q",           restart "xmonad" True               ) -- restart xmonad
    , ("M-S-q",         io (exitWith ExitSuccess)           ) -- quit
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
    , ("M-h",           sendMessage Shrink                  ) -- Shrink master
    , ("M-l",           sendMessage Expand                  ) -- Expand master
    , ("M-t",           withFocused $ windows . W.sink      ) -- Demote window
    , ("M-,",           sendMessage (IncMasterN 1)          ) -- master_count++
    , ("M-.",           sendMessage (IncMasterN (-1))       ) -- master_count--
    , ("M-b",           sendMessage ToggleStruts            ) -- toggle the status bar gap

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
    , ("M-`",           raise isBuddyList                   ) -- Focus pidgin conv window
    , ("M-s m",         runOrRaise "prism-google-mail"      $ "Gmail"           `isPrefixOfQ` pName)
        , ("M-s c",     runOrRaise "prism-google-calendar"  $ "Google Calendar" `isPrefixOfQ` pName)
        , ("M-s r",     runOrRaise "prism-google-reader"    $ "Google Reader"   `isPrefixOfQ` pName)
        , ("M-s f",     runOrRaise "firefox -P default"     $ pClass =? "Firefox")
        , ("M-s g",     spawn "firefox -P default" )
        , ("M-s i",     spawn "firefox -P testing -no-remote" )
    , ("M-S-l",         spawn "gnome-screensaver-command -l"  )
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
            searchSite  = S.promptSearch xpc
            mouseFollow = warpToWindow (1%4) (1%4)
            xpcAuto     = xpc {autoComplete = Just 500000}
            xpcSub      = xpc {autoComplete = Just 100000, subString = True}
            xpc         = defaultXPConfig { font     = "xft:DejaVu Sans-10"
                                          , bgColor  = "black"
                                          , fgColor  = "grey"
                                          , promptBorderWidth = 1
                                          , position = Bottom
                                          , height   = 30
                                          , historySize = 256 }
            -- Look for a pidgin non-irc window
            isBuddyList = pClass =? "Pidgin"
                                <&&> pRole =? "conversation"
                                <&&> not <$> '#' `elemQ` appName


myKeys2 conf = fromList $
    [ ((0, 0x1008ff11), spawn "amixer -q sset Master 5-") -- vol--
    , ((0, 0x1008ff13), spawn "amixer -q sset Master 5+") -- vol++
    , ((0, 0x1008ff12), spawn "amixer -q sset Master toggle") -- mute
    , ((0, 0x1008ff2a), spawn $ terminal conf)
    ]

myMouseBindings (XConfig {modMask = modMask}) = fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))    -- mod-button1, Set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster)) -- mod-button2, Raise the window to the top of the stack , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))  -- mod-button3, Set the window to floating mode and resize by dragging -- you may also bind events to the mouse scroll wheel (button4 and button5)
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

------------------------------------------------------------------------
-- Layouts:

myLayout = layoutHints . smartBorders . avoidStruts
         $ onWorkspace "10:chat"   (IM.withIM (1%10) isPidgin $ Mirror tiled)
         $ onWorkspace "8:skype"   (IM.withIM (2%10) isSkype  $ Mirror tiled)
         $ tiled ||| spiral ||| Full
    where
        tiled    = Tall 1 (3%100) (3%5)
        spiral   = spiralWithDir Spiral.East Spiral.CW (5%8)
        isPidgin = IM.And (IM.ClassName "Pidgin") (IM.Role "buddy_list")
        isSkype  = IM.And (IM.ClassName "Skype.real") (IM.Title "novas0x2a - Skype")

------------------------------------------------------------------------
-- Window rules:

say :: String -> IO ExitCode
say s = system $ "/bin/echo '" ++ s ++ "' >> /home/mike/xmonad.log"
sayHook = return True --> (say <$> (return "hi") >> idHook)

-- Use xprop. Not all props supported:
myManageHook :: IORef Integer -> ManageHook
myManageHook floatNextWindows = composeAll $ concat
    [[ manageDocks]
    ,[ pName  =? name               --> doFloat | name <- floatByName]
    ,[ googleReaderSub              --> doFloat]
    ,[ pClass =? name               --> doF (W.shift workspace) | (name, workspace) <- shifts ]
    ,[ (> 0) `liftM` io (readIORef floatNextWindows)
                                    --> do io (modifyIORef floatNextWindows pred) >> doCenterFloat ]
    ]
    where
        googleReaderSub  = pClass =? "Prism" <&&> pRole =? "Webrunner"
        --googleEarthPopup = pClass =? "Googleearth-bin"
        floatByName     = ["Passphrase", "osgviewerGLUT", "please-float-me"]
        shifts = ("Skype.real", "8:skype") : ("Twitux", "9:twitter") : ("Pidgin","10:chat") : []


--myWorkspaces = ["α","β","γ","δ","ε","ζ","η","θ","ι","κ","λ","μ","ν","ξ","ο","π","ρ","σ","τ","υ","φ","χ","ψ","ω"]
myWorkspaces = map show [1..]

main = do
    xmobar           <- spawnPipe "xmobar"
    floatNextWindows <- newIORef 0
    xmonad $ defaultConfig {
      -- simple stuff
        terminal           = "xterm",
        focusFollowsMouse  = True,
        borderWidth        = 1,
        modMask            = mod4Mask,
        numlockMask        = mod2Mask,
        workspaces         = zipWith (++) [show x ++ ":" | x <- [1..]] $ (take 7 myWorkspaces) ++ ["skype", "twitter", "chat"],
        --workspaces         = (take 7 myWorkspaces) ++ ["skype", "twitter", "chat"],
        normalBorderColor  = "#888888",
        focusedBorderColor = "#0000FF",

      -- key bindings
        keys               = \c -> myKeys floatNextWindows c `union` myKeys2 c,
        --keys               = \c -> myKeys c `union` myKeys2 c,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook floatNextWindows,
        startupHook        = setWMName "LG3D",
        logHook            = dynamicLogWithPP $ xmobarPP
                             { ppOutput = UTF8.hPutStrLn xmobar
                             , ppUrgent = xmobarColor "#ff0000" ""
                             , ppTitle  = xmobarColor "#ffff00" ""
                             , ppExtras = [do
                                             i <- io $ readIORef floatNextWindows
                                             return $ Just $ if i == 0
                                                                 then "-"
                                                                 else show i
                                          ]
                             }
    }
