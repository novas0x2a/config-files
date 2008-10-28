import XMonad hiding (Tall)

import XMonad.Actions.CycleRecentWS         (cycleRecentWS)
import XMonad.Actions.CycleWS
import XMonad.Actions.FindEmptyWorkspace    (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Actions.WindowGo              (raise, runOrRaise)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.HintedTile
import XMonad.Layout.PerWorkspace           (onWorkspace)
import XMonad.Layout.Spiral                 (spiralWithDir)
import XMonad.Layout.LayoutHints            (layoutHints)

import XMonad.Prompt
import XMonad.Prompt.Man                    (manPrompt)
--import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Shell                  (shellPrompt)
import XMonad.Prompt.Ssh                    (sshPrompt)
import XMonad.Prompt.Window                 (windowPromptBring, windowPromptGoto)
import XMonad.Prompt.XMonad                 (xmonadPrompt)

import XMonad.Util.EZConfig                 (mkKeymap)
import XMonad.Util.Run                      (spawnPipe, hPutStrLn)
import XMonad.Util.WorkspaceCompare         (getSortByIndex)

import Control.Applicative                  ((<$>))
import Control.Arrow                        ((&&&))
import Data.List                            (stripPrefix)
import Data.Maybe                           (fromMaybe)
import List                                 (isPrefixOf)
import System.Exit

import qualified Data.Map                       as M
import qualified XMonad.Actions.FlexibleResize  as Flex
import qualified XMonad.Actions.Search          as S
import qualified XMonad.Layout.IM               as IM
import qualified XMonad.StackSet                as W
import qualified System.IO.UTF8
import qualified XMonad.Layout.Spiral           as Spiral

isPrefixOfQ = fmap . isPrefixOf

elemQ :: Eq a => a -> Query [a] -> Query Bool
elemQ needle haystack = do
    str <- haystack
    return $ needle `elem` str

-- Look for a pidgin non-irc window
isPidginIM = className =? "Pidgin"
        <&&> stringProperty "WM_WINDOW_ROLE" =? "conversation"
        <&&> not <$> '#' `elemQ` stringProperty "WM_NAME"

xpc :: XPConfig
xpc = defaultXPConfig { font     = "xft:DejaVu Sans-10"
                      , bgColor  = "black"
                      , fgColor  = "grey"
                      , promptBorderWidth = 1
                      , position = Bottom
                      , height   = 30
                      , historySize = 256 }

xpcAuto = xpc {autoComplete = Just 500000}
xpcSub  = xpc {autoComplete = Just 100000, subString = True}

followTo :: WSDirection -> WSType -> X ()
followTo d t = do
    id <- findWorkspace getSortByIndex d t 1
    merge . run $ id where
        run :: WorkspaceId -> (X (), X ())
        run = (windows . W.shift) &&& (windows . W.greedyView)
        merge :: (X (), X ()) -> X ()
        merge = uncurry (>>)

myKeys conf = mkKeymap conf $
    -- WM Manipulation Commands
    [ ("M-q",           restart "xmonad" True               ) -- restart xmonad
    , ("M-S-q",         io (exitWith ExitSuccess)           ) -- quit
    , ("M-S-c",         kill                                ) -- close focused window

    -- Within A Workspace
    , ("M-<Space>",     sendMessage NextLayout              ) -- Rotate through layouts
    , ("M-S-<Space>",   setLayout $ XMonad.layoutHook conf  ) -- Set layout list to default
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
    , ("M-<U>",         moveTo Next EmptyWS                 ) -- go to empty
    , ("M-<D>",         moveTo Next EmptyWS                 ) -- go to empty
    , ("M-S-<U>",       shiftTo Next EmptyWS                ) -- Push current window away
    , ("M-S-<D>",       tagToEmptyWorkspace                 ) -- Take current window with me
    , ("M-<R>",         moveTo Next HiddenNonEmptyWS        ) -- go to next non-empty
    , ("M-<L>",         moveTo Prev HiddenNonEmptyWS        ) -- go to prev non-empty
    --, ("M-<Tab>",       cycleRecentWS [xK_Meta_L] xK_Tab xK_Tab) -- Switch between windows
    , ("M-z",           toggleWS                            ) -- Switch between windows
    , ("M-S-<R>",       shiftToNext >> nextWS               ) -- Move window to next
    , ("M-S-<L>",       shiftToPrev >> prevWS               ) -- Move window to prev
    , ("M-w",           nextScreen                          ) -- Move focus to next screen
    , ("M-S-w",         shiftNextScreen                     ) -- Move window to next screen

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
    , ("M-'",           spawn $ XMonad.terminal conf        ) -- Terminal
    , ("M-`",           raise isPidginIM                    ) -- Focus pidgin conv window
    , ("M-s m",         runOrRaise "prism-google-mail"      $ "Gmail"           `isPrefixOfQ` title)
        , ("M-s c",     runOrRaise "prism-google-calendar"  $ "Google Calendar" `isPrefixOfQ` title)
        , ("M-s r",     runOrRaise "prism-google-reader"    $ "Google Reader"   `isPrefixOfQ` title)
        , ("M-s f",     runOrRaise "firefox -P default"     $ className =? "Firefox")
        , ("M-s g",     spawn "firefox -P default" )
        , ("M-s i",     spawn "firefox -P testing -no-remote" )
    , ("M-S-l",         spawn "gnome-screensaver-command -l"  )
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) $ map show $ [1..9] ++ [0]
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
            searchSite = S.promptSearch xpc

myKeys2 = M.fromList $
    [ ((0, 0x1008ff11), spawn "amixer -q sset Master 5-") -- vol--
    , ((0, 0x1008ff13), spawn "amixer -q sset Master 5+") -- vol++
    , ((0, 0x1008ff12), spawn "amixer -q sset Master toggle") -- mute
    , ((0, 0x1008ff2a), spawn myTerm)
    ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))    -- mod-button1, Set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster)) -- mod-button2, Raise the window to the top of the stack , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))  -- mod-button3, Set the window to floating mode and resize by dragging -- you may also bind events to the mouse scroll wheel (button4 and button5)
    , ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w))
    ]

------------------------------------------------------------------------
-- Layouts:

-- IM layout, 1 master (buddy list), 10% wide
myLayout = avoidStruts $ onWorkspace "chat" im all where
    normal  = HintedTile 1 (3/100) (1/2) Center
    spiral  = spiralWithDir Spiral.East Spiral.CW (5/8)
    im      = IM.withIM (10/100) (IM.And (IM.ClassName "Pidgin") (IM.Role "buddy_list")) $ normal Wide
    all     = normal Tall ||| layoutHints spiral ||| layoutHints Full

------------------------------------------------------------------------
-- Window rules:

-- Use xprop. Not all props supported:
myManageHook = manageDocks <+> composeAll (concat
    [ [title     =? "please-float-me"  --> doFloat]
    , [title     =? "please-ignore-me" --> doIgnore]
    , [className =? "Twitux"           --> doF(W.shift "twitter")]
    , [className =? "Pidgin"           --> doF(W.shift "chat")]
    ])


myStartupHook = do
    return ()
    -- args <- getArgs
    -- windows $ W.greedyView "twitter"
    -- refresh
    -- windows $ W.greedyView "chat"
    -- refresh
    -- windows $ W.greedyView "1"

myTerm = "xterm"

-- myWorkspaces = ["α","β","γ","δ","ε","ζ","η","θ","ι","κ","λ","μ","ν","ξ","ο","π","ρ","σ","τ","υ","φ","χ","ψ","ω"]
myWorkspaces = map show [1..]

main = do
    xmobar <- spawnPipe "xmobar"
    xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerm,
        focusFollowsMouse  = True,
        borderWidth        = 1,
        modMask            = mod4Mask,
        numlockMask        = mod2Mask,
        workspaces         = (take 8 myWorkspaces) ++ ["twitter", "chat"],
        normalBorderColor  = "#888888",
        focusedBorderColor = "#0000FF",

      -- key bindings
        keys               = \c -> myKeys c `M.union` myKeys2,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        startupHook        = myStartupHook,
        logHook            =
            dynamicLogWithPP $ xmobarPP {
                ppOutput = System.IO.UTF8.hPutStrLn xmobar,
                ppTitle  = xmobarColor "#ffff00" ""
            }
        --    dynamicLogWithPP $ defaultPP
        --    {ppCurrent  = xmobarColor "#dd0000" ""
        --    ,ppHidden   = xmobarColor "black" ""
        --    ,ppLayout   = \s -> case fromMaybe s $ stripPrefix "Hinted " s of
        --                   "Mirror Tall"    -> "Wide"
        --                   s                -> s
        --    ,ppSep      = " | "
        --    ,ppTitle    = xmobarColor "#000000" "" . shorten 70
        --    ,ppOutput   = hPutStrLn xmobar
        --    }
    }
