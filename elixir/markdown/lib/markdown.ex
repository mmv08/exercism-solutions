defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown_input) do
    markdown_input
    |> String.split("\n")
    |> Enum.map_join(fn t -> process_lines(t) end)
    |> replace_emphasis_tags()
    |> add_ul_tag()
  end

  defp process_lines("#" <> t), do: t |> parse_header(1)
  defp process_lines("* " <> t), do: "<li>#{t}</li>"
  defp process_lines(str), do: "<p>#{str}</p>"

  defp parse_header(" " <> t, lvl), do: "<h#{lvl}>#{t}</h#{lvl}>"
  defp parse_header("#" <> t, lvl), do: parse_header(t, lvl + 1)

  defp replace_emphasis_tags(str) do
    str
    |> String.replace(~r/__([^_]+)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_([^_]+)_/, "<em>\\1</em>")
  end

  defp add_ul_tag(str) do
    str
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix(
      "</li>",
      "</li></ul>"
    )
  end
end
