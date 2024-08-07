local hunk = require("lua.git.internal.hunk")

describe("hunk test", function()
	describe("hunk.new", function()
		it("parses full header properly", function()
			local h = hunk.new(
				{
					"diff --git a/example b/example",
					"index 74f564b..a32da07 100644",
					"--- a/example",
					"+++ b/example"
				},
				"@@ -1,6 +1,7 @@"
			)
			assert.equal(1, h.old_pos)
			assert.equal(6, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(7, h.new_len)
		end)
		it("parses header properly when old was single line", function()
			local h = hunk.new(
				{
					"diff --git a/example b/example",
					"index 74f564b..a32da07 100644",
					"--- a/example",
					"+++ b/example"
				},
				"@@ -1 +1,2 @@"
			)
			assert.equal(1, h.old_pos)
			assert.equal(1, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(2, h.new_len)
		end)
		it("parses header properly when new is single line", function()
			local h = hunk.new(
				{
					"diff --git a/example b/example",
					"index 74f564b..a32da07 100644",
					"--- a/example",
					"+++ b/example"
				},
				"@@ -1,2 +1 @@"
			)
			assert.equal(1, h.old_pos)
			assert.equal(2, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(1, h.new_len)
		end)
		it("parses header properly when old and new are single line", function()
			local h = hunk.new(
				{
					"diff --git a/example b/example",
					"index 74f564b..a32da07 100644",
					"--- a/example",
					"+++ b/example"
				},
				"@@ -1 +1 @@"
			)
			assert.equal(1, h.old_pos)
			assert.equal(1, h.old_len)
			assert.equal(1, h.new_pos)
			assert.equal(1, h.new_len)
		end)
	end)
end)
