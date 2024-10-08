import XMonad
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog (statusBar, xmobarPP, xmobarColor, ppCurrent, wrap, ) 
import XMonad.Util.EZConfig (additionalKeysP) 
import Graphics.X11.Xlib (KeySym, KeyMask, xK_b)


import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal 	= "alacritty"
myModMask 	= mod4Mask
myBorderWidth 	= 1

-- Workspaces
myWorkspaces 	= ["1", "2", "3", "4", "5"]

-- Border Colors (B = Normal, FB = Focus Border)
-- myBColor	= "#403d52"
myBColor = "#000000"
-- myFBColor	= "#ebbcba"
myFBColor = "#666666"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ 

    ((modm, xK_Return), spawn $ XMonad.terminal conf)
    
    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

    -- Firefox
    , ((modm, xK_f     ), spawn "firefox")

    -- Spawn Slack
    , ((modm, xK_s     ), spawn "slack") 

    -- Spawn Google Chrome 
    , ((modm, xK_g     ), spawn "google-chrome-stable")

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.

myPP = xmobarPP { ppCurrent = xmobarColor "429942" "" . wrap "|" "|" }

-- Key Binding to toggle the gap for the bar
-- toggleStructsKey :: XConfig 1 -> (KeyMask, KeySym)
toggleStructsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

-- Defaults

defaults = def
	{ terminal 		= myTerminal 
	, modMask  		= myModMask 
	, borderWidth		= myBorderWidth
	, workspaces		= myWorkspaces
	, normalBorderColor	= myBColor
	, focusedBorderColor	= myFBColor
	, keys			= myKeys
	}

-- Setup
-- include myBar after statusBar
main :: IO ()
main = xmonad defaults
-- main = xmonad defaults


