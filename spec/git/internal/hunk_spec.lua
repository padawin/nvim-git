local hunk = require("lua.git.internal.hunk")
local ins = require 'inspect'

describe("hunk test", function()
	describe("hunk.new", function()
		it("parses full header properly", function()
			local h = hunk.new("@@ -1,6 +1,7 @@")
			assert.equal(1, h.old_pos)
			assert.equal(6, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(7, h.new_len)
		end)
		it("parses header properly when old was single line", function()
			local h = hunk.new("@@ -1 +1,2 @@")
			assert.equal(1, h.old_pos)
			assert.equal(1, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(2, h.new_len)
		end)
		it("parses header properly when new is single line", function()
			local h = hunk.new("@@ -1,2 +1 @@")
			assert.equal(1, h.old_pos)
			assert.equal(2, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(1, h.new_len)
		end)
		it("parses header properly when old and new are single line", function()
			local h = hunk.new("@@ -1 +1 @@")
			assert.equal(1, h.old_pos)
			assert.equal(1, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(1, h.new_len)
		end)
	end)

	describe("hunk.get_content", function()
		local h
		before_each(function()
			h = hunk.new("@@ -1,6 +1,7 @@")
			hunk.add_line(h, " context 1")
			hunk.add_line(h, " context 2")
			hunk.add_line(h, " context 3")
			hunk.add_line(h, "+new line")
			hunk.add_line(h, " context 4")
			hunk.add_line(h, " context 5")
			hunk.add_line(h, " context 6")
		end)
		it("returns a table with all the lines of a hunk", function()
			local content = hunk.get_content(h)
			assert.equal(
				ins({
					"@@ -1,6 +1,7 @@",
					 " context 1",
					 " context 2",
					 " context 3",
					 "+new line",
					 " context 4",
					 " context 5",
					 " context 6",
				 }),
				ins(content)
			)
		end)
	end)
end)
