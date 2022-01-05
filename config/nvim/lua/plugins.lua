vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
	use 'tidalcycles/vim-tidal'
  use 'sophacles/vim-processing'
	use 'forrestbaer/minimal_dark'
  use 'easymotion/vim-easymotion'
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'folke/trouble.nvim'
  use 'fatih/vim-go'
	use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'rmagatti/auto-session'
  use 'nvim-telescope/telescope-fzf-native.nvim'
  use 'airblade/vim-gitgutter'
  use 'akinsho/toggleterm.nvim'
  use 'jamessan/vim-gnupg'
  use {
    'vimwiki/vimwiki',
    config = function()
      vim.g.vimwiki_list = {{
        path = '~/store/wiki',
        syntax = 'markdown',
        ext = '.md'
      }}
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
