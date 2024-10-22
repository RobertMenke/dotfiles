local Git = {}

function Git:BranchName()
  local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
  if branch ~= '' then
    vim.fn.setreg('+', branch)
  else
    vim.cmd 'echo "No branch name to copy"'
  end
end

return Git
