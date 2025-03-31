local M = {}
local map = vim.keymap.set
local util = require 'lspconfig.util'

-- Angular requires a node_modules directory for @angular/language-service and TypeScript
local function get_probe_dir(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)
  return project_root and (project_root .. '/node_modules') or ''
end

-- on_attach function for common key mappings
M.on_attach = function(_, bufnr)
  local opts = function(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  -- LSP key mappings
  local mappings = {
    { "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
    { "n", "gd", vim.lsp.buf.definition, "Go to definition" },
    { "n", "gi", vim.lsp.buf.implementation, "Go to implementation" },
    { "n", "<leader>sh", vim.lsp.buf.signature_help, "Show signature help" },
    { "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
    { "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
    { "n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "List workspace folders" },
    { "n", "<leader>D", vim.lsp.buf.type_definition, "Go to type definition" },
    { "n", "<leader>ra", require("nvchad.lsp.renamer"), "Rename symbol" },
    { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action" },
    { "n", "gr", vim.lsp.buf.references, "Show references" },
  }

  for _, map_args in ipairs(mappings) do
    map(map_args[1], map_args[2], map_args[3], opts(map_args[4]))
  end
end

-- Disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- Enhanced capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  },
}

-- Default LSP configurations
M.defaults = function()
  dofile(vim.g.base46_cache .. "lsp")
  require("nvchad.lsp").diagnostic_config()

  -- Lua LS setup
  require("lspconfig").lua_ls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }

  -- Angular LS setup
  local project_library_path = get_probe_dir(vim.fn.getcwd())
  local angular_cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations", project_library_path,
    "--ngProbeLocations", project_library_path,
  }

  require("lspconfig").angularls.setup {
    cmd = angular_cmd,
    on_new_config = function(new_config, _)
      new_config.cmd = angular_cmd
    end,
    root_dir = util.root_pattern "angular.json",
  }

  -- Additional LSP servers
  local servers = { "ts_ls", "cssmodules_ls", "emmet_ls", "jdtls" }
  for _, server in ipairs(servers) do
    require("lspconfig")[server].setup {
      on_attach = M.on_attach,
      capabilities = M.capabilities,
    }
  end
  require("lspconfig").jdtls.setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    root_dir = require("lspconfig").util.root_pattern("pom.xml", "build.gradle", ".git") or vim.fn.getcwd(),
    settings = {
      java = {
        home = 'C:/Program Files/Java/jdk-17',  -- specify your JDK location here
      },
    },
  })
  -- Java setup
  require("java").setup()
end

return M
