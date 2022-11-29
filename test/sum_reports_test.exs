defmodule GenReport.SumReportsTest do
  use ExUnit.Case

  alias GenReport.SumReports

  describe "sum/2" do
    test "when it receives iqual reports it returns the sum of the reports" do
      report1 = %{a: 1, b: %{a: 1, b: 2}, c: %{a: 1, b: %{a: 1, b: 2}}}
      report2 = %{a: 1, b: %{a: 1, b: 2}, c: %{a: 1, b: %{a: 1, b: 2}}}

      response = SumReports.sum(report1, report2)

      expected_response = %{a: 2, b: %{a: 2, b: 4}, c: %{a: 2, b: %{a: 2, b: 4}}}

      assert response == expected_response
    end

    test "when it receives different reports it returns the sum of the reports" do
      report1 = %{a: 1, b: %{a: 1, b: 2}, c: %{a: 1, b: %{a: 1, b: 2}}, d: 2}
      report2 = %{a: 1, b: %{a: 1, b: 2}, c: %{a: 1, b: %{a: 1, b: 2}}, e: %{a: 1}}

      response = SumReports.sum(report1, report2)

      expected_response = %{a: 2, b: %{a: 2, b: 4}, c: %{a: 2, b: %{a: 2, b: 4}}, d: 2, e: %{a: 1}}

      assert response == expected_response
    end

    test "when it receives only one report it returns the report" do
      report1 = %{a: 1, b: %{a: 1, b: 2}, c: %{a: 1, b: %{a: 1, b: 2}}, d: 2}

      assert SumReports.sum(report1, nil) == report1
      assert SumReports.sum(nil, report1) == report1
    end

    test "when it receives numbers returns the sum of the numbers" do
      report1 = %{a: 1, b: %{a: 1, b: 2}, c: %{a: 1, b: %{a: 1, b: 2}}, d: 2}

      assert SumReports.sum(1, 1) == 2
      assert SumReports.sum(nil, 1) == 1
      assert SumReports.sum(1, nil) == 1
    end
  end
end
