# /nix/home/nixvim.nix
{ nixvim, pkgs, ... }: {

  imports = [
    nixvim.homeModules.nixvim
  ];

  # nixvim
  programs.nixvim = {
    enable = true;
    
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
			background = "dark";

			clipboard = {
			  register = "unnamedplus";
			  providers.wl-copy.enable = true; # for Wayland
			};
    };

		# spellcheck
		  spellcheck = {
		    enable = true;
		    settings = {
		      lang = "en";
		      use_nerd_font_symbols = true;
		    };
		  };

	
		# theme
		colorschemes.tokyonight = {
	    enable = true;
	    settings.style = "night";
	    settings.transparent = true;
	  };
		
		plugins = {
			nioce.enable = true;
			lualine.enable = true;
			web-devicons.enable = true;
			telescope.enable = true;
			oil.enable = true;
		  which-key.enable = true;
			gitsigns.enable = true;
			lazygit.enable = true;

		  spellsitter = {
			    enable = true;
			    settings = {
			      enable = true;
			      langs = [ "en" ];
			    };
			  };


		  # === TOGGLETERM: Терминал внутри Neovim ===
		  toggle-term = {
		    enable = true;
		    settings = {
		      size = 80;                    # Размер терминала (в столбцах или строках)
		      open_mapping = "[[<leader>t]]"; # Горячая клавиша (Leader + t)
		      hide_numbers = true;          # Скрыть номера строк в терминале
		      shade_filetypes = {};         # Не затемнять другие файлы
		      shade_terminals = true;       # Затемнять сам терминал (для фокуса)
		      shading_factor = 2;           # Степень затемнения
		      start_in_insert = true;       # Сразу входить в режим вставки
		      persist_size = true;          # Запоминать размер окна
		      direction = "float";          # Варианты: "float", "vertical", "horizontal", "tab"
		      
		      # Настройки плавающего окна (если direction = "float")
		      float_opts = {
		        border = "curved";          # Рамка: "single", "double", "curved", "none"
		        width = 120;
		        height = 40;
		        winblend = 3;               # Прозрачность фона (0-100)
		      };
		    };
		  };


			luasnip.enable = true;
			cmp = {
				enalbe = true;
				settins.source = [
					{ name = "nvim_lsp"; }
					{ name = "path"; }
					{ name = "buffer"; }
				];
			};

			lsp = {
				enable = true;
				servers = {
			    nil_ls.enable = true;
			    clangd.enable = true;
					cmake.enable = true;
			    bashls.enable = true;
					jsonls.enable = true;
			  };
			};

			# doxygen
			extraPlugins = [
		    pkgs.vimPlugins.vim-doxygen
		  ];

		  extraConfigLua = ''
		    -- doxygen settings
		    vim.g.doxygen_enable_mappings = 1
		    vim.g.doxygen_use_double_slash = 1
		    vim.g.doxygen_param_auto = 1
		    vim.g.doxygen_return_auto = 1
		  '';
		};
  };
}
