return {
    'jpalardy/vim-slime',
    init = function ()
    	vim.g.slime_target = 'neovim'
	vim.g.slime_python_ipython = 1
	vim.g.slime_dispatch_ipython_pause = 100
	vim.g.slime_cell_delimiter = '#\\s\\=%%'
	vim.cmd [[
	  function SlimeOverride_EscapeText_quarto(text)
	  call v:lua.Quarto_is_in_python_chunk()
	  if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
	  return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
	  else
	  if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
	  return [a:text, "\n"]
	  else
	  return [a:text]
	  end
	  end
	  endfunction
      ]]
    end,
    config = function ()
	vim.keymap.set({ 'n', 'i' }, '<m-cr>', function ()
	   vim.cmd [[ call slime#send_cell() ]]
	end, { desc = 'send code cell to terminal' })
    end,
}
