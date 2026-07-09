-- Snacks explorer: focus the file LIST on open instead of the search input.
-- The file-op keys (a=add, d=delete, r=rename, c=copy, m=move) are defined on
-- the list window only — with focus in the input box, `a` is just vim's
-- "append" and drops you back into the search field.
-- Focus switching either way: Alt+w cycles input <-> list; `i` from the list
-- jumps to the input to filter.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          focus = "list",
          -- Transparent sidebar: the explorer windows map NormalFloat to
          -- SnacksPicker* groups that carry a solid mantle bg, and snacks
          -- re-applies winhighlight after on_show, so neither per-source
          -- win.wo nor patching the option sticks. A window-scoped highlight
          -- namespace does: it overrides the bg for these two windows only
          -- (other snacks pickers, e.g. code-action menus, keep solid bgs).
          on_show = function(picker)
            local ns = vim.api.nvim_create_namespace("explorer_transparent")
            for _, group in ipairs({ "SnacksPickerList", "SnacksPickerInput" }) do
              local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
              hl.bg = nil
              vim.api.nvim_set_hl(ns, group, hl)
            end
            for _, name in ipairs({ "list", "input" }) do
              local w = picker[name] and picker[name].win
              if w and w.win and vim.api.nvim_win_is_valid(w.win) then
                vim.api.nvim_win_set_hl_ns(w.win, ns)
              end
            end
          end,
        },
      },
    },
  },
}
