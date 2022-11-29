defmodule GenReport do
  alias GenReport.Parser
  alias GenReport.SumReports

  def build_from_many(filenames) when not is_list(filenames), do: {:error, "Please proide a list of string"}

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(%{}, fn {:ok, result}, report -> SumReports.sum(result, report) end)
  end

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build(), do: {:error, "Insira o nome de um arquivo"}

  defp sum_values(line, report) do
    report
    |> update_all_hours(line)
    |> update_hours_per_year(line)
    |> update_hours_per_month(line)
  end

  defp update_all_hours(%{ "all_hours" => all_hours } = report, [name, hours, _day, _month, _year]) do
    new_all_hours = Map.update(all_hours, name, hours, fn old_hours -> old_hours + hours end)

    %{ report | "all_hours" => new_all_hours }
  end

  defp update_hours_per_year(%{ "hours_per_year" => hours_per_year } = report, [name, hours, _day, _month, year]) do
    default_value = Map.put(%{}, year, hours)

    new_hours_per_year = Map.update(hours_per_year, name, default_value, fn hours_in_year ->
      new_hours_in_year = Map.update(hours_in_year, year, hours, fn old_hours -> old_hours + hours end)

      Map.merge(hours_in_year, new_hours_in_year)
    end)

    %{ report | "hours_per_year" => new_hours_per_year }
  end

  defp update_hours_per_month(%{ "hours_per_month" => hours_per_month } = report, [name, hours, _day, month, _year]) do
    default_value = Map.put(%{}, month, hours)

    new_hours_per_month = Map.update(hours_per_month, name, default_value, fn hours_in_month ->
      new_hours_in_month = Map.update(hours_in_month, month, hours, fn old_hours -> old_hours + hours end)

      Map.merge(hours_in_month, new_hours_in_month)
    end)

    %{ report | "hours_per_month" => new_hours_per_month }
  end

  defp report_acc do
    %{ "all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{} }
  end
end
