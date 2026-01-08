return {
  'ph1losof/shelter.nvim',
  build = 'lua build.lua',
  opts = {
    skip_comments = false,
    default_mode = 'partial',
    modules = {
      files = true,
      snacks_previewer = true,
    },
  },
}
