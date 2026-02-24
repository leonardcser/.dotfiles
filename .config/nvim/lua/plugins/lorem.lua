return {
	"derektata/lorem.nvim",
	cmd = "LoremIpsum",
	config = function()
		require("lorem").opts({
			sentence_length = "mixed",
			comma_chance = 0.3,
			max_commas = 2,
			debounce_ms = 500,
		})
	end,
}
