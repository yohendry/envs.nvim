


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
  - [1. install](#1-install)
    - [lazy](#lazy)
  - [2. config](#2-config)
  - [3. usage](#3-usage)
  - [4. screenshots](#4-screenshots)
<!--toc:end-->

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
		title = "   envs ", -- popup window title
		border = "single", -- popup border style
		style = "minimal", -- popup window style
	},
	close_mappings = { "q", "<Esc>" }, -- kesy bindigs for the popup to close
}
```

## 3. usage
- `:ShowEnv`
- use `open_mapping` hotkey

to show ENV value under cursor

## 4. screenshots

