<!--toc:start-->
- [NOT WORKING RN](#not-working-rn)
- [envs.nvim](#envsnvim)
  - [1. install](#1-install)
    - [lazy](#lazy)
  - [2. config](#2-config)
  - [3. usage](#3-usage)
  - [4. screenshots](#4-screenshots)
<!--toc:end-->

# NOT WORKING RN

# envs.nvim
nvim plugin that shows the value of system wide or project specific enviroment variable under the cursor


## 1. install

### lazy
```lua
{ "yohendry/envs.nvim", config = true }
```

## 2. config
```lua
{
	popup = true, -- display a popup window relative to the cursor
	print = true, -- prnts the env value to `messages`
	window = {
		title = "   print env ", -- popup window title
		border = "single", -- popup border style
		style = "minimal", -- popup window style
	},
	close_mappings = { "q", "<Esc>" }, -- kesy bindigs for the popup to close
	open_mapping = "<C-e>", -- key bindigs for show or print the ENV value
}
```

## 3. usage
- `:ShowEnv`
- use `open_mapping` hotkey

to show ENV value under cursor

## 4. screenshots

