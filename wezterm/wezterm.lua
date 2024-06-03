local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- カラースキームの設定
config.color_scheme = 'Dracula+'
config.char_select_bg_color = "#282A36"
config.char_select_fg_color = "#F8F8F2"

-- フォント
config.font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", style="Normal"})

-- フォントサイズ
config.font_size = 15

-- デフォルトの背景透過
config.window_background_opacity = 0.85

-- 最初からフルスクリーンで起動
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
end)

-- 画面分割時の透過率
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.4,
}

-- スクロールバックサイズ
config.scrollback_lines = 3500

-- 透過率調整
wezterm.on("decrease-opacity", function(window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 1.0
    end
    overrides.window_background_opacity = overrides.window_background_opacity - 0.1
    if overrides.window_background_opacity < 0.1 then
        overrides.window_background_opacity = 0.1
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("increase-opacity", function(window)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        overrides.window_background_opacity = 1.0
    end
    overrides.window_background_opacity = overrides.window_background_opacity + 0.1
    if overrides.window_background_opacity > 1.0 then
        overrides.window_background_opacity = 1.0
    end
    window:set_config_overrides(overrides)
end)


-- ショートカットキー設定
local act = wezterm.action
config.keys = {
  -- ¥ではなく、バックスラッシュを入力する。おそらくMac固有
  {
      key = "¥",
      action = wezterm.action.SendKey { key = '\\' }
  },
  -- Altを押した場合はバックスラッシュではなく¥を入力する。おそらくMac固有
  {
      key = "¥",
      mods = "ALT",
      action = wezterm.action.SendKey { key = '¥' }
  },
  -- ⌘ + でフォントサイズを大きくする
  {
      key = "+",
      mods = "CMD|SHIFT",
      action = wezterm.action.IncreaseFontSize,
  },
  -- ⌘ w でペインを閉じる（デフォルトではタブが閉じる）
  {
      key = "w",
      mods = "CMD",
      action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Alt(Opt)+Shift+Fでフルスクリーン切り替え
  {
      key = 'f',
      mods = 'SHIFT|META',
      action = wezterm.action.ToggleFullScreen,
  },
  -- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
  { key = '8', mods = 'CTRL', action = act.PaneSelect },
  -- activate pane selection mode with numeric labels
  {
    key = '9',
    mods = 'CTRL',
    action = act.PaneSelect {
      alphabet = '1234567890',
    },
  },
  -- show the pane selection mode, but have it swap the active and selected panes
  {
    key = '0',
    mods = 'CTRL',
    action = act.PaneSelect {
      mode = 'SwapWithActive',
    },
  },
  -- Ctrl+Shift+tで新しいタブを作成
  {
      key = 't',
      mods = 'CMD|SHIFT',
      action = act.SpawnTab 'CurrentPaneDomain',
  },
  -- Ctrl+Shift+dで新しいペインを作成(右方向に画面を分割)
  {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Ctrl+Shift+dで新しいペインを作成(下方向に画面を分割)
  {
      key = 'd',
      mods = "CMD|SHIFT",
      action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } },
  },
  -- ⌘ Ctrl Shift hjklでペイン境界の調整
  {
      key = 'h',
      mods = 'CMD|CTRL|SHIFT',
      action = wezterm.action.AdjustPaneSize { 'Left', 2 },
  },
  {
      key = 'j',
      mods = 'CMD|CTRL|SHIFT',
      action = wezterm.action.AdjustPaneSize { 'Down', 2 },
  },
  {
      key = 'k',
      mods = 'CMD|CTRL|SHIFT',
      action = wezterm.action.AdjustPaneSize { 'Up', 2 },
  },
  {
      key = 'l',
      mods = 'CMD|CTRL|SHIFT',
      action = wezterm.action.AdjustPaneSize { 'Right', 2 },
  },
  -- 透過率調整
  {
      key = "n",
      mods = "CMD|CTRL|SHIFT",
      action = wezterm.action { EmitEvent = "decrease-opacity" },
  },
  {
      key = "m",
      mods = "CMD|CTRL|SHIFT",
      action = wezterm.action { EmitEvent = "increase-opacity" },
  },
}

-- マウス操作の挙動設定
config.mouse_bindings = {
    -- 右クリックでクリップボードから貼り付け
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = wezterm.action.PasteFrom 'Clipboard',
    },
}

return config

