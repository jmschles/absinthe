defmodule Absinthe.Phase.Document.Execution.EscapeSequenceTest do
  use Absinthe.Case, async: true

  defmodule Schema do
    use Absinthe.Schema

    query do
      field :thing, :whatever do
        resolve(fn _, _ -> {:ok, %{}} end)
      end
    end

    object :whatever do
      field :escape_test, :string do
        arg :sequence, :string

        resolve(fn args, _ ->
          {:ok, args.sequence}
        end)
      end
    end
  end


  @sequence "/\\\\W+/"
  test "escape sequences are not subject to extra encoding or decoding" do
    doc = """
    {
      thing { escapeTest(sequence: "#{@sequence}") }
    }
    """
    assert {:ok, %{data: %{"thing" => %{"escapeTest" => @sequence}}}} == Absinthe.run(doc, Schema)
  end
end
