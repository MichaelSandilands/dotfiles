local wk = require 'which-key'

-- normal mode with <leader>
wk.add({
  { '<leader>q', group = '[q]uarto' },
  {
    '<leader>qE',
    function()
      require('otter').export(true)
    end,
    desc = '[E]xport with overwrite',
  },
  { '<leader>qa', ':QuartoActivate<cr>', desc = '[a]ctivate' },
  { '<leader>qe', require('otter').export, desc = '[e]xport' },
  { '<leader>qh', ':QuartoHelp ', desc = '[h]elp' },
  { '<leader>qp', ":lua require'quarto'.quartoPreview()<cr>", desc = '[p]review' },
  { '<leader>qu', ":lua require'quarto'.quartoUpdatePreview()<cr>", desc = '[u]pdate preview' },
  { '<leader>qq', ":lua require'quarto'.quartoClosePreview()<cr>", desc = '[q]uiet preview' },
  { '<leader>qr', group = '[r]un' },
  { '<leader>qra', ':QuartoSendAll<cr>', desc = 'run [a]ll' },
  { '<leader>qrb', ':QuartoSendBelow<cr>', desc = 'run [b]elow' },
  { '<leader>qrr', ':QuartoSendAbove<cr>', desc = 'to cu[r]sor' },
}, { mode = 'n' })
