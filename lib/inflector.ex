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
        Map.put(inflector, :uncountables, [value] ++ inflector.uncountables)
    end

    def plural(inflector, rule, replacement) do
        Map.put(inflector, :plurals, [[rule, replacement]] ++ inflector.plurals)
    end

    def singular(inflector, rule, replacement) do
        Map.put(inflector, :singulars, [[rule, replacement]] ++ inflector.singulars)
    end

    def irregular(inflector, singular, plural) do
        singular = String.downcase(singular)
        plural = String.downcase(plural)

        inflector
            |> plural(Regex.compile!(List.to_string(["\\b", singular, "\\b"]), "i"), plural)
            |> singular(Regex.compile!(List.to_string(["\\b", plural, "\\b"]), "i"), singular)
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

    def replace(uncountables, rules, word) do
        downcase_word = String.downcase(word)

        if Enum.find_index(uncountables, fn(value) -> value == downcase_word end) != nil do
            word
        else
            recur_replace(word, rules, 0, length(rules))
        end
    end
    def recur_replace(word, rules, index, length) do
        pattern = Enum.at(rules, index)
        rule = Enum.at(pattern, 0)

        if Regex.match?(rule, word) do
            Regex.replace(rule, word, Enum.at(pattern, 1))
        else
            index = index + 1

            if index < length do
                recur_replace(word, rules, index, length)
            else
                word
            end
        end
    end
end
