return {
    {
        "ellisonleao/dotenv.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("dotenv").setup({
                file_name = vim.fn.expand("~/.config/er_llm.env"),
                enable_on_load=true,
            })
        end,
    },
}
