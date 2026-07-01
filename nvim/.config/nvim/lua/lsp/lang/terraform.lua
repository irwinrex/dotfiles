vim.lsp.config("terraformls", {
  settings = {
    terraform = {
      rootModules = { "." },
      experimentalFeatures = {
        validateOnSave = true,
        prefillRequiredFields = true,
      },
    },
  },
})
vim.lsp.enable("terraformls")
