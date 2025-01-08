-- enclose.nvim
local M = {}

-- Enclose function
function M.enclose()
    local chars = vim.fn.input("Enter surrounding characters: ")

    -- Define matching pairs for common opening and closing characters
    local matching_pairs = {
        ["{"] = "}",
        ["["] = "]",
        ["("] = ")",
        ["<"] = ">",
        ["'"] = "'",
        ['"'] = '"'
    }

    local char_start, char_end
    local len = #chars

    if len == 1 then
        char_start = chars
        char_end = matching_pairs[chars] or chars
    elseif len > 1 then
        if chars:sub(1, 1) == chars:sub(len, len) then
            char_start = chars:sub(1, 1)
            char_end = matching_pairs[char_start] or char_start
        else
            char_start = chars:sub(1, 1)
            char_end = chars:sub(len, len)
        end
    else
        return
    end

    if chars ~= "" then
        local count = vim.v.count > 0 and vim.v.count or 1

        local start_repeated = string.rep(char_start, count)
        local end_repeated = string.rep(char_end, count)

        vim.cmd(string.format("'<,'>s/\\%%V.*\\%%V./%s&%s/",
            vim.fn.escape(start_repeated, '\\<>'),
            vim.fn.escape(end_repeated, '\\<>')))
    end
end

function M.setup(mode, key)
    if not mode or not key then
        error("Both mode and key must be provided to M.setup()")
    end

    vim.keymap.set(mode, '<leader>' .. key, "<cmd>lua require'enclose'.enclose()<CR>")
end

return M
