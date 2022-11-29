defmodule GenReport.SumReports do
  def sum(%{} = report1, %{} = report2) do
    extrac_reports_keys(report1, report2)
    |> Enum.map(fn key -> Map.put(%{}, key, sum(report1[key], report2[key])) end)
    |> Enum.reduce(%{}, fn acc, report ->  Map.merge(acc, report) end)
  end

  def sum(report, nil), do: report
  def sum(nil, report), do: report

  def sum(number1, number2), do: number1 + number2

  defp extrac_reports_keys(report1, report2) do
    Map.keys(report1) ++ Map.keys(report2)
    |> Enum.uniq()
  end
end
