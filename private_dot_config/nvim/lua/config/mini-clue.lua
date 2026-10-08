local miniclue = require("mini.clue")

miniclue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    { mode = "i", keys = "<C-x>" },

    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    { mode = "n", keys = "<C-w>" },

    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    { mode = "n", keys = "<Leader>c", desc = "+code" },
    { mode = "x", keys = "<Leader>c", desc = "+code" },
    { mode = "n", keys = "<Leader>d", desc = "+debug" },
    { mode = "n", keys = "<Leader>f", desc = "+find" },
    { mode = "n", keys = "<Leader>g", desc = "+git" },
    { mode = "n", keys = "<Leader>h", desc = "+hunk" },
    { mode = "n", keys = "<Leader>s", desc = "+search" },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})
