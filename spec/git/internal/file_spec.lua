local file = require("git.internal.file")
local hunk = require("git.internal.hunk")
local ins = require 'inspect'

local with_hunk = function()
	h = hunk.new("@@ -1,6 +1,7 @@")
	hunk.add_line(h, " context 1")
	hunk.add_line(h, " context 2")
	hunk.add_line(h, " context 3")
	hunk.add_line(h, "+new line")
	hunk.add_line(h, " context 4")
	hunk.add_line(h, " context 5")
	hunk.add_line(h, " context 6")
	return h
end

describe("file test", function()
	describe("file.get_content", function()
		it("returns the whole diff", function()
			local f = file.new("diff --git a/example b/example")
			file.complete_header(f, "index 1aa10cb..172c4e5 100644")
			file.complete_header(f, "--- a/example")
			file.complete_header(f, "+++ b/example")
			file.add_hunk(f, with_hunk())
			file.add_hunk(f, with_hunk())
			assert.equal(
				ins({
					"diff --git a/example b/example",
					"index 1aa10cb..172c4e5 100644",
					"--- a/example",
					"+++ b/example",
					"@@ -1,6 +1,7 @@",
					" context 1",
					" context 2",
					" context 3",
					"+new line",
					" context 4",
					" context 5",
					" context 6",
					"@@ -1,6 +1,7 @@",
					" context 1",
					" context 2",
					" context 3",
					"+new line",
					" context 4",
					" context 5",
					" context 6",
				}),
				ins(file.get_content(f))
			)
		end)
	end)
end)
