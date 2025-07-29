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
    },
    keys = {
        { "<leader>cc", function() require("codecompanion").chat() end, desc = "Open CodeCompanion Chat" },
    }
}
