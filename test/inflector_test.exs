defmodule InflectorTest do
    use ExUnit.Case
    doctest Inflector

    test "should pluralize strings" do
        inflector = Inflector.new()
            |> Inflector.plural(Regex.compile!("$", "i"), "s")
            |> Inflector.plural(Regex.compile!("(ch|sh|ss|[sxz])$", "i"), "\\1es")
            |> Inflector.plural(Regex.compile!("([^aeiouy])y$", "i"), "\\1ies")
            |> Inflector.irregular("woman", "women")
            |> Inflector.uncountable("rice")

        assert Inflector.pluralize(inflector, "box") == "boxes"
        assert Inflector.pluralize(inflector, "sky") == "skies"
        assert Inflector.pluralize(inflector, "bucket") == "buckets"
        assert Inflector.pluralize(inflector, "rice") == "rice"
        assert Inflector.pluralize(inflector, "woman") == "women"
    end

    test "should singularize strings" do
        inflector = Inflector.new()
            |> Inflector.singular(Regex.compile!("s$", "i"), "")
            |> Inflector.singular(Regex.compile!("(ch|sh|ss|[sxz])es$", "i"), "\\1")
            |> Inflector.singular(Regex.compile!("([^aeiouy])ies$", "i"), "\\1y")
            |> Inflector.irregular("man", "men")
            |> Inflector.uncountable("deer")

        assert Inflector.singularize(inflector, "boxes") == "box"
        assert Inflector.singularize(inflector, "skies") == "sky"
        assert Inflector.singularize(inflector, "buckets") == "bucket"
        assert Inflector.singularize(inflector, "deer") == "deer"
        assert Inflector.singularize(inflector, "men") == "man"
    end
end
