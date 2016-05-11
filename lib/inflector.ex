defmodule Inflector do
    defstruct [
        plurals: [],
        singulars: [],
        uncountables: []
    ]

    def new() do
        %Inflector{}
    end
    def create(), do: new()

    def uncountable(inflector, value) do
        Map.put(inflector, :uncountables, inflector.uncountables ++ [value])
    end

    def plural(inflector, rule, replacement) do
        Map.put(inflector, :plurals, inflector.plurals ++ [[rule, replacement]])
    end

    def singular(inflector, rule, replacement) do
        Map.put(inflector, :singulars, inflector.singulars ++ [[rule, replacement]])
    end

    def irregular(inflector, singular, plural) do
        singular = String.downcase(singular)
        plural = String.downcase(plural)

        inflector
            |> plural(Regex.compile!("\\b" <> singular <> "\\b", "i"), plural)
            |> singular(Regex.compile!("\\b" <> plural <> "\\b", "i"), singular)
    end

    def pluralize(inflector, word) do
        replace(inflector.uncountables, inflector.plurals, word)
    end

    def is_plural(inflector, word) do
        singularize(inflector, word) != word
    end

    def singularize(inflector, word) do
        replace(inflector.uncountables, inflector.singulars, word)
    end

    def is_singular(inflector, word) do
        pluralize(inflector, word) != word
    end

    defp replace(uncountables, rules, word) do
        downcase_word = String.downcase(word)

        if Enum.find_index(uncountables, fn(value) -> value == downcase_word end) != nil do
            word
        else
            recursive_replace(word, rules, length(rules))
        end
    end

    defp recursive_replace(word, _, 0), do: word
    defp recursive_replace(word, rules, index) do
        i = index - 1
        pattern = Enum.at(rules, i)
        rule = Enum.at(pattern, 0)

        if Regex.match?(rule, word) do
            Regex.replace(rule, word, Enum.at(pattern, 1))
        else
            recursive_replace(word, rules, i)
        end
    end
end
