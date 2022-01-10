vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
	use 'tidalcycles/vim-tidal'
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
  use 'rmagatti/auto-session'
  use 'nvim-telescope/telescope-fzf-native.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use 'airblade/vim-gitgutter'
  use 'akinsho/toggleterm.nvim'
  use 'luukvbaal/nnn.nvim'
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