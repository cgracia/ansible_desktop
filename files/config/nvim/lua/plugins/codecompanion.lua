return {
  "olimorris/codecompanion.nvim",
  name = "codecompanion",
  event = "VeryLazy",
  opts = {
    agents = {
      openai = {
        model = "gpt-4o",
        key = os.getenv("AI_API_KEY"),
        endpoint = os.getenv("AI_ENDPOINT"),
      },
    },
    strategies = {
      chat = {
        keymaps = {
          send = { modes = { n = "<C-s>", i = "<C-s>" }, description = "Send message to LLM" },
          close = { modes = { n = "<C-q>", i = "<C-q>" }, description = "Close the chat buffer" },
          stop = { modes = { n = "q" }, description = "Stop the current LLM response" },
          change_adapter = { modes = { n = "ga" }, description = "Change LLM adapter (model/provider)" },
          insert_codeblock = { modes = { n = "gc" }, description = "Insert an empty markdown code block" },
          debug = { modes = { n = "gd" }, description = "Open debug window with full chat data" },
          fold_code = { modes = { n = "gf" }, description = "Fold/unfold all code blocks in chat" },
          pin_context = { modes = { n = "gp" }, description = "Pin a context item (refresh it every turn)" },
          watch_buffer = { modes = { n = "gw" }, description = "Watch current buffer for changes as context" },
          regenerate = { modes = { n = "gr" }, description = "Re-generate the last LLM answer" },
          goto_file = { modes = { n = "gR" }, description = "Go to file under cursor (open file in tab)" },
          toggle_system_prompt = { modes = { n = "gs" }, description = "Toggle the system prompt on/off" },
          usage_stats = { modes = { n = "gS" }, description = "Show Copilot usage statistics (if available)" },
          toggle_auto_tools = { modes = { n = "gta" }, description = "Toggle automatic tool usage mode" },
          clear_chat = { modes = { n = "gx" }, description = "Clear all chat buffer contents" },
          yank_last_codeblock = { modes = { n = "gy" }, description = "Yank (copy) last code block from chat" },
          show_options = { modes = { n = "?" }, description = "Show all CodeCompanion keymaps (help menu)" },
        },
      },
      inline = {
        keymaps = {
          accept_change = { modes = { n = "ga" }, description = "Accept the suggested inline code change" },
          reject_change = { modes = { n = "gr" }, description = "Reject the suggested inline code change" },
        },
      },
    },
    -- Add any other opts/UI settings here
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)

    local keymap = vim.keymap.set
    -- Main palette & chat window toggling (these can stay as string commands)
    keymap({ "n", "v" }, "<leader>cc", "<CMD>CodeCompanionActions<CR>", { desc = "CodeCompanion Action Palette" })
    keymap({ "n", "v" }, "<leader>ct", "<CMD>CodeCompanionChat Toggle<CR>", { desc = "Toggle CodeCompanion Chat" })
    -- Visual selection to chat context
    keymap("v", "<leader>cs", "<CMD>CodeCompanionChat Add<CR>", { desc = "Send Selection to Chat" })
    -- Visual prompt shortcuts (these are now functions for safety)
    keymap("v", "<leader>ce", function() vim.cmd("CodeCompanion /explain") end, { desc = "Explain Selection" })
    keymap("v", "<leader>cf", function() vim.cmd("CodeCompanion /fix") end, { desc = "Fix/Refactor Selection" })
    keymap("v", "<leader>cd", function() vim.cmd("CodeCompanion /lsp") end, { desc = "Explain LSP Diagnostic" })
    keymap("v", "<leader>cu", function() vim.cmd("CodeCompanion /tests") end, { desc = "Generate Unit Tests" })
    keymap("v", "<leader>cm", function() vim.cmd("CodeCompanion /commit") end, { desc = "Generate Commit Message" })

    -- Optional: Command-line abbreviation
    vim.cmd([[cabbrev cc CodeCompanion]])

    -- WHICH-KEY: Register all <leader>c mappings for discoverability
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.register({
        c = {
          name = "CodeCompanion",
          c = { "<CMD>CodeCompanionActions<CR>", "Action Palette" },
          t = { "<CMD>CodeCompanionChat Toggle<CR>", "Toggle Chat" },
          s = { "<CMD>CodeCompanionChat Add<CR>", "Send Selection to Chat" },
          e = { function() vim.cmd("CodeCompanion /explain") end, "Explain Selection" },
          f = { function() vim.cmd("CodeCompanion /fix") end, "Fix/Refactor Selection" },
          d = { function() vim.cmd("CodeCompanion /lsp") end, "Explain LSP Diagnostic" },
          u = { function() vim.cmd("CodeCompanion /tests") end, "Generate Unit Tests" },
          m = { function() vim.cmd("CodeCompanion /commit") end, "Generate Commit Message" },
        }
      }, { prefix = "<leader>", mode = { "n", "v" } })
    end
  end,
}
