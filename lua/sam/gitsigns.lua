local M = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "Gitsigns",
  keys = {
    { "<leader>g", desc = "Git" },
  },
}

M.config = function()
  local icons = require "sam.icons"

  require("gitsigns").setup {
    signs = {
      add = { text = icons.ui.BoldLineMiddle },
      change = { text = icons.ui.BoldLineDashedMiddle },
      delete = { text = icons.ui.TriangleShortArrowRight },
      topdelete = { text = icons.ui.TriangleShortArrowRight },
      changedelete = { text = icons.ui.BoldLineMiddle },
    },
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    update_debounce = 200,
    max_file_length = 40000,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, {expr=true, desc = "Next hunk"})

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, {expr=true, desc = "Previous hunk"})

      -- Actions
      map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
      map("v", "<leader>gs", function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Stage hunk" })
      map("v", "<leader>gr", function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Reset hunk" })
      map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
      map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
      map("n", "<leader>gl", function() gs.blame_line{full=true} end, { desc = "Blame line" })
      map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
      map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff this ~" })
      map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

      -- Text object
      map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
    end
  }
end

return M
