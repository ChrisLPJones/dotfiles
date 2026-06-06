
return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
        "rafamadriz/friendly-snippets", -- Predefined snippets for many languages
    },
    config = function()
        local luasnip = require("luasnip")

        -- Load VSCode-style snippets from friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Optionally, define custom snippets
        -- Example: C# property
        luasnip.add_snippets("cs", {
            luasnip.snippet("prop", {
                luasnip.text_node("public "), 
                luasnip.insert_node(1, "int"), 
                luasnip.text_node(" "), 
                luasnip.insert_node(2, "MyProperty"), 
                luasnip.text_node(" { get; set; }")
            }),
        })

        -- Python example snippet
        luasnip.add_snippets("python", {
            luasnip.snippet("def", {
                luasnip.text_node("def "), 
                luasnip.insert_node(1, "function_name"), 
                luasnip.text_node("("), 
                luasnip.insert_node(2, ""), 
                luasnip.text_node("):"), 
                luasnip.text_node({"", "\t"}), 
                luasnip.insert_node(0)
            }),
        })

        -- JavaScript / TypeScript / React snippets
        for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
            luasnip.add_snippets(ft, {
                -- Example: React functional component
                luasnip.snippet("rfc", {
                    luasnip.text_node("const "), 
                    luasnip.insert_node(1, "ComponentName"), 
                    luasnip.text_node(" = () => {"),
                    luasnip.text_node({"", "\treturn ("}),
                    luasnip.text_node({"", "\t\t"}), 
                    luasnip.insert_node(0), 
                    luasnip.text_node({"", "\t);", "}"})
                }),
            })
        end

        -- HTML snippet
        luasnip.add_snippets("html", {
            luasnip.snippet("html5", {
                luasnip.text_node("<!DOCTYPE html>"),
                luasnip.text_node({"", "<html lang=\"en\">"}),
                luasnip.text_node({"", "<head>"}),
                luasnip.text_node({"", "\t<meta charset=\"UTF-8\">"}),
                luasnip.text_node({"", "\t<title>"}), 
                luasnip.insert_node(1, "Title"), 
                luasnip.text_node("</title>"),
                luasnip.text_node({"", "</head>", "<body>"}), 
                luasnip.text_node({"", "\t"}), 
                luasnip.insert_node(0),
                luasnip.text_node({"", "</body>", "</html>"}),
            }),
        })

        -- CSS snippet
        luasnip.add_snippets("css", {
            luasnip.snippet("center", {
                luasnip.text_node("{"),
                luasnip.text_node({"", "\tdisplay: flex;"}),
                luasnip.text_node({"", "\tjustify-content: center;"}),
                luasnip.text_node({"", "\talign-items: center;"}),
                luasnip.text_node({"", "}"}),
            }),
        })
    end
}

