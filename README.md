


# envs.nvim
nvim plugin that shows the value of system wide or project specific enviroment variable under the cursor

# tl;dr
```lua
{
	"yohendry/envs.nvim",
	event = "LspAttach",
	config = function()
		require("envs").setup({
			popup = true, -- display a popup window relative to the cursor
			print = false, -- prnts the env value to `messages`
			window = {
				title = "   envs ", -- popup window title
				border = "double", -- popup border style
				style = "minimal", -- popup window style
			},
			close_mappings = { "q", "<Esc>" }, -- key bindigs to close the popup
		})
		vim.keymap.set("n", "E", "<cmd>ShowEnv<cr>", { buffer = 0, desc = "Show Env variable value under cursor" })
	end,
	name = "envs",
}

```


<!--toc:start-->
- [envs.nvim](#envsnvim)
- [tl;dr](#tldr)
  - [Install](#install)
    - [lazy](#lazy)
  - [Config](#config)
  - [Usage](#usage)
  - [Screenshots](#screenshots)
<!--toc:end-->

## Install

### lazy
```lua
{ "yohendry/envs.nvim", config = true }
```

## Config
```lua
{
	popup = true, -- display a popup window relative to the cursor
	print = true, -- prnts the env value to `messages`
	window = {
		title = "   envs ", -- popup window title
		border = "single", -- popup border style
		style = "minimal", -- popup window style
	},
	close_mappings = { "q", "<Esc>" }, -- kesy bindigs for the popup to close
}
```

## Usage
- `:ShowEnv`
- use `open_mapping` hotkey

to show ENV value under cursor

## Screenshots

