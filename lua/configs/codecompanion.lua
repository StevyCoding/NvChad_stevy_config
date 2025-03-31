local options = {
  -- Enable the plugin
  enable = true,

  -- Define the Anthropic adapter
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = vim.env.ANTHROPIC_API_KEY or "", -- Get from environment variable
        },
        options = {
          model = "claude-3-7-sonnet-20250219", -- Latest Claude model
          max_tokens = 4000,
          temperature = 0.7,
        },
        system = [[You are Jarvis, an AI assistant integrated with Neovim through CodeCompanion.
You help users write, understand, and improve their code.
Keep explanations clear and focused on the coding task at hand.]],
      })
    end,
  },

  -- Set Anthropic as the default adapter
  default_adapter = "anthropic",

  -- Override strategy defaults to use Anthropic
  strategies = {
    chat   = { adapter = "anthropic" },
    inline = { adapter = "anthropic" },
    agent  = { adapter = "anthropic" },
  },

  -- Optional UI configurations
  ui = {
    border = "rounded",
    width = 80,
    height = 20,
  },
}

return options
