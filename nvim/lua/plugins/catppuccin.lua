-- ~/.config/nvim/lua/user/plugins/catppuccin.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "frappe", -- Choose "latte", "frappe", "macchiato", "mocha"
      integrations = {
        -- Enable integrations for plugins you use (optional)
        telescope = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
        },
      },
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}
