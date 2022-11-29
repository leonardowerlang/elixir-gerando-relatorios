defmodule GenReport.SumReports do
  def sum(%{} = report1, %{} = report2) do
    report1
    |> Enum.map(fn {key, _value} -> Map.put(%{}, key, sum(report1[key], report2[key])) end)
    |> Enum.reduce(%{}, fn acc, report ->  Map.merge(acc, report) end)
  end

  def sum(%{} = report, nil), do: report

  def sum(number1, number2), do: number1 + number2
end
