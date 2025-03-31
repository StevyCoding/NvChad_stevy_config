return {
    -- Core dependencies
    "nvim-lua/plenary.nvim",
    {
        "nvchad/base46",
        build = function()
            require("base46").load_all_highlights()
        end,
    },
    {
        "nvchad/ui",
        lazy = false, -- Load immediately since it's essential for the UI
        config = function()
            require("nvchad")
        end,
    },
    "nvzone/volt",
    "nvzone/menu",
    {
        "nvzone/minty",
        cmd = { "Huefy", "Shades" }, -- Load only when these commands are called
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true, -- Load only when needed
        opts = function()
            dofile(vim.g.base46_cache .. "devicons")
            return {
                override = require("nvchad.icons.devicons"),
            }
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost", -- Load after a file is opened
        opts = {
            indent = {
                char = "│",
                highlight = "IblChar",
            },
            scope = {
                char = "│",
                highlight = "IblScopeChar",
            },
        },
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "blankline")
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            require("ibl").setup(opts)
        end,
    },
    -- File managing, picker, etc.
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" }, -- Load only when these commands are called
        opts = function()
            return require("configs.nvimtree")
        end,
    },
    {
        "folke/which-key.nvim",
        keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" }, -- Load on these keybindings
        cmd = "WhichKey",
        opts = function()
            dofile(vim.g.base46_cache .. "whichkey")
            return {}
        end,
    },
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- Load before saving a file
        opts = function()
            return require("configs.conform")
        end,
    },
    -- Git stuff
    {
        "lewis6991/gitsigns.nvim",
        event = "User FilePost", -- Load after a file is opened
        opts = function()
            return require("configs.gitsigns")
        end,
    },
    -- LSP stuff
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" }, -- Load only when these commands are called
        opts = function()
            return require("nvchad.configs.mason")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = "User FilePost", -- Load after a file is opened
        config = function()
            require("configs.lspconfig").defaults()
        end,
    },
    -- Load luasnips + cmp related in insert mode only
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- Load when entering insert mode
        dependencies = {
            {
                -- Snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = {
                    history = true,
                    updateevents = "TextChanged,TextChangedI",
                },
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                    require("configs.luasnip")
                end,
            },
            {
                -- Autopairing of (){}[] etc
                "windwp/nvim-autopairs",
                event = "InsertEnter", -- Load when entering insert mode
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)
                    -- Setup cmp for autopairs
                    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },
            -- Cmp sources plugins
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
        },
        opts = function()
            return require("nvchad.configs.cmp")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "Telescope", -- Load only when the Telescope command is called
    event = "VeryLazy",  
    opts = function()
            return require("configs.telescope")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" }, -- Load when opening a file
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = function()
            return require("nvchad.configs.treesitter")
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        cmd = "Telescope", -- Load only when the Telescope command is called
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-tree.lua" },
        event = "User FilePost", -- Load after a file is opened
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    -- Adding new plugins
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach", -- Load when LSP attaches to a buffer
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter", -- optional
            "nvim-tree/nvim-web-devicons", -- optional
        },
    },
    {
        "LunarVim/bigfile.nvim",
        event = "BufEnter", -- Load when entering a buffer
    },
    {
        "nvim-java/nvim-java",
        event = "BufEnter", -- Load when entering a buffer
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-refactor",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            {
                "JavaHello/spring-boot.nvim",
                commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
            },
            {
                "williamboman/mason.nvim",
                opts = {
                    registries = {
                        "github:nvim-java/mason-registry",
                        "github:mason-org/mason-registry",
                    },
                },
            },
        },
    },
    {
        "hedyhli/outline.nvim",
        cmd = { "Outline", "OutlineOpen" }, -- Load only when these commands are called
        keys = {
            { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" }, -- Example mapping
        },
        opts = {
            -- Your setup opts here
        },
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy", -- Load lazily
        config = function()
            vim.notify = require("notify")
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
        event = "VeryLazy", -- Load lazily
        opts = function()
            return require("configs.codecompanion")
        end,
        config = function(_, opts)
            require("codecompanion").setup(opts)
        end,
    },
    {
        'Exafunction/codeium.vim',
        event = 'BufEnter',
        config = function()
            vim.g.codeium_no_map_tab = true -- Disable Tab for accepting suggestions
    
            -- Remap C-g to accept the suggestion
            vim.keymap.set("i", "<C-g>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })
        end
    }
}
