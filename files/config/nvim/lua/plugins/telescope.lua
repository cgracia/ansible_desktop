return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = "Find Files" })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set('n', '<leader>sk', "<cmd>Telescope keymaps<cr>", { desc = "Search Keymaps" })
    vim.keymap.set('n', '<leader>sb', "<cmd>Telescope buffers<cr>", { desc = "Search Buffers" })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "Find Files" }) -- optional, if you want sg/sf/both

    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register({
        s = {
          name = "Search",
          f = { "<cmd>Telescope find_files<cr>", "Find Files" },
          g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
          b = { "<cmd>Telescope buffers<cr>", "Buffers" },
          k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        },
      }, { prefix = "<leader>" })
    end
  end,
}
