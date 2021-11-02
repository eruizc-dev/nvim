local dap = require("dap")
local util = require("jdtls.util")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup {
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    -- experimental features:
    virt_text_pos = 'eol', -- position of virtual text, see :h nvim_buf_set_extmark()
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
                            -- e.g. 80 to position at column 80 see :h nvim_buf_set_extmark()
}

dapui.setup()

dap.adapters.java = function(callback)
  util.execute_command({command = 'vscode.java.startDebugSession'}, function(err0, port)
    assert(not err0, vim.inspect(err0))
    callback({
      type = 'server';
      host = '127.0.0.1';
      port = port;
    })
  end)
end
dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode",
  name = "lldb"
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    runInTerminal = false,
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.java = {
  {
    type = 'java';
    request = 'attach';
    name = "Debug (Attach) - Remote";
    hostName = "127.0.0.1";
    port = 5005;
  },
}
dap.configurations.rust = dap.configurations.cpp

local util = require('jdtls.util')

dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = "Java attach",
    hostName = "127.0.0.1",
    port = 5005
  },
}

