local function search_forward(opts)
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode if necessary
	local save_cursor = vim.fn.getcurpos()
	vim.cmd([[normal! 0]])
	local cur_line = vim.fn.line(".")
	local searchPattern = [[\V]] .. vim.fn.escape(opts.char, [[\]])
	local new_line = vim.fn.search(searchPattern, "cnW")
	if new_line == 0 then
		vim.fn.setpos(".", save_cursor)
		return
	else
		if
			opts.create_mark_on_jump_larger_than ~= nil
			and (new_line - cur_line) > opts.create_mark_on_jump_larger_than
		then
			-- This is a long distance, so the jump was possibly accidental.
			-- Set the ' mark to allow the user to get back easily.
			-- Cursor was in first column. Restore cursor position, so the ` mark is at the right place.
			vim.fn.setpos(".", save_cursor)
			vim.fn.search(searchPattern, "csW")
		else
			vim.fn.search(searchPattern, "cW")
		end
		if opts.type == "i" then
			vim.fn.search([[\v\S]], "b")
		end
		vim.cmd([[normal! v^]])
	end
end

local function create_mappings(opts)
	for _, c in ipairs(opts.separators) do
		vim.keymap.set({ "x", "o" }, "<Plug>(textobj-before-i" .. c .. ")", function()
			search_forward({
				char = c,
				type = "i",
				create_mark_on_jump_larger_than = opts.create_mark_on_jump_larger_than,
			})
		end, { desc = "Text in current or following line before " .. c })
		vim.keymap.set({ "x", "o" }, "<Plug>(textobj-before-a" .. c .. ")", function()
			search_forward({ char = c, type = "a" })
		end, { desc = "Text in current or following line up to and including " .. c })
	end
	for _, c in ipairs(opts.separators) do
		vim.keymap.set({ "x", "o" }, opts.prefix_i .. c, "<Plug>(textobj-before-i" .. c .. ")")
		vim.keymap.set({ "x", "o" }, opts.prefix_a .. c, "<Plug>(textobj-before-a" .. c .. ")")
	end
end

return {
	create_mappings = create_mappings,
	search_forward = search_forward,
}
