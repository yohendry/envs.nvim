# envs.nvim
nvim plugin that shows the value of system wide or project specific enviroment variable under the cursor

# tl;dr
```lua
{
    "yohendry/envs.nvim",
    event = { "BufRead", "BufNew" },
    config = true,
    name = "envs",
    keys = {
        { "<C-;>", "<cmd>ShowEnv<cr>", desc = "Lookup as ENV var" },
    },
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
{
    "yohendry/envs.nvim",
    event = { "BufRead", "BufNew" },
    config = function()
        require("envs").setup({
            not_found_prefix = "¯\\_(ツ)_/¯ "
        })
    end,
    name = "envs",
    keys = {
        { "<C-;>", "<cmd>ShowEnv<cr>", desc = "Lookup as ENV var" },
    },
}
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
	not_found_prefix = " ",
	close_mappings = { "q", "<Esc>" }, -- key bindigs to close the popup
}
```

## Usage
- `:ShowEnv`
- use `open_mapping` hotkey

to show ENV value under cursor

## Screenshots

