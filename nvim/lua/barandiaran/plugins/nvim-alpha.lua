return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = "VimEnter",
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set Header
    dashboard.section.header.val = {
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠾⣿⣿⣷⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠋⠚⠀⠀⠀⠀⠀⠀⢠⣾⣷⣶⣶⣾⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣠⠏⠈⠉⠉⠉⠉⣻⣿⡇⠙⠿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠊⠁⠀⠀⠀⠳⢄⡀⠀⠀⠀⠀⢿⠿⢇⣀⣤⣬⣻⣿⣿⣇⠀⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢤⡀⠀⠀⠀⠻⠿⠟⠻⢿⣿⣟⢿⡆⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⢴⣺⠷⢀⠀⠀⠀⠀⠀⢤⡀⠀⠀⠀⠀⣾⣿⡿⢠⣷⠀⠀⠀⠀⢀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢇⠀⠀⠀⠀⠀⠀⠊⠡⠖⢂⡀⠀⠀⠀⠈⠲⣄⠀⠀⠈⠉⢁⣿⡟⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⡀⠀⢀⡀⠀⠀⠀⠀⠙⠿⠓⠀⠀⠀⠀⠀⠙⠂⠀⠀⣾⣿⠃⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠓⠬⣉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡯⢤⣀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠁⠀⠀⠀⠀⣠⢾⡀⠀⠀⠀⠉⠒⠂⠤⠄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠈⠃⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠏⠀⠀⠀⢀⡜⠁⠀⠑⡆⠀⠀⠐⣄⠀⠀⠀⠀⠀⠉⠉⠉⠙⣖⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣏⣀⡀⠀⠀⠈⠒⠦⡀⠸⢆⡀⠀⠀⠀⠀⠀⠀⠀⠈⢲⡤⣀⣀⣀⡠⠴⠋⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀⠈⠓⢄⡀⠀⠀⠈⠓⢾⣉⢦⡀⠀⠀⠀⣠⢧⠀⠀⠓⢦⠀⠀⠀⠀⠀⡀⠀⠀⠀',
      '⡠⠤⠤⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⡀⠀⠀⠀⠀⠉⠉⠑⢦⡀⠀⠀⠉⠁⠀⢀⡴⠁⠀⠙⠢⢤⠈⠳⣄⠀⠀⠀⠺⠿⠀⠀',
      '⠓⡦⠒⡶⢿⡓⠦⠤⣀⠀⠀⠀⠀⠀⠀⠀⠉⠓⡶⠤⣀⣠⣧⠀⠀⠉⠙⢦⡀⠀⣠⠞⠀⠀⠀⠀⠀⠀⠉⠙⠧⡽⣦⠀⠀⠀⠀⠀',
      '⠀⡇⠀⠀⠶⠓⠀⠀⠘⠳⣤⠶⣄⠀⠀⠀⠀⢀⡇⠀⢸⠀⠸⠶⢤⣀⠀⠀⠈⡹⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      '⠀⢙⡦⢄⢀⣄⠀⠀⠀⣋⠹⢧⡈⢳⡀⠠⣶⠯⣤⠒⠉⡠⠞⠀⣠⠀⠙⠒⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      '⢠⣎⡤⠤⢭⡛⠳⡄⠀⠈⠀⢀⣏⠉⠁⠀⠀⠉⠛⠒⠿⣦⣖⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      '⠈⠉⠀⠀⠀⢨⠇⣈⣁⣒⠒⠉⠈⢳⡤⢲⠆⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      '⠀⠀⠀⠀⠀⡫⠞⠁⢹⡼⠛⢦⠀⠀⣏⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
    }

    -- Load sessions from auto-session
    local sessions_dir = vim.fn.stdpath("data") .. "/sessions"
    local uv = vim.loop
    local session_buttons = {}

    local function decode_session_name(file)
      return file:gsub("%%", "%%%%"):gsub("___", "/")
    end

    local handle = uv.fs_scandir(sessions_dir)
    if handle then
      table.insert(session_buttons, dashboard.button(" ", "📂  Sessions", ":echo ''<CR>"))
      while true do
        local name, t = uv.fs_scandir_next(handle)
        if not name then break end
        if t == "file" and name:match("%.vim$") then
          local display_name = decode_session_name(name:gsub("%.vim$", ""))
          table.insert(session_buttons,
            dashboard.button(
              tostring(#session_buttons),
              "  " .. display_name,
              string.format(":lua require('auto-session').RestoreSession('%s/%s')<CR>", sessions_dir, name)
            )
          )
        end
      end
    end

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
      unpack(session_buttons),
    }

    -- Footer
    dashboard.section.footer.val = { "Have a productive day!" }

    -- Setup Alpha
    alpha.setup(dashboard.opts)
  end,
}
