return {
	{ "tpope/vim-dadbod", cmd = "DB" },
	{ "kristijanhusak/vim-dadbod-ui", dependencies = { "tpope/vim-dadbod" }, cmd = { "DBUI", "DBUIToggle" } },
	{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
}

