defmodule NanomartError do
  defexception message: "Some error happened"
end

defmodule Item do
  defmacro __using__(_opts) do
    quote do
      defstruct [:output, :prompter]

      def restrictions do
        []
      end

      defoverridable [restrictions: 0]
    end
  end
end

defmodule Item.Cola do
  use Item

  def restrictions do
    []
  end
end

defmodule Item.MisoSoup do
  use Item

  def restrictions do
    []
  end
end

defmodule Item.Beer do
  use Item

  def restrictions do
    [true]
  end
end

defmodule Item.Whiskey do
  use Item

  def restrictions do
    [true]
  end
end

defmodule Item.Cigarettes do
  use Item

  def restrictions do
    [true]
  end
end

defmodule Nanomart do
  @moduledoc """
  Nanomart for selling items.
  """

  defstruct [:output, :prompter]

  def sell_me(%__module__{} = nanomart, item_name) do
    item = case item_name do
      :cola ->
        %Item.Cola{output: nanomart.output, prompter: nanomart.prompter}
      :miso_soup ->
        %Item.MisoSoup{output: nanomart.output, prompter: nanomart.prompter}
      :beer ->
        %Item.Beer{output: nanomart.output, prompter: nanomart.prompter}
      :whiskey ->
        %Item.Whiskey{output: nanomart.output, prompter: nanomart.prompter}
      :cigarettes ->
        %Item.Cigarettes{output: nanomart.output, prompter: nanomart.prompter}
    end

    Enum.map(item.__struct__.restrictions, fn(restriction) ->
      raise NanomartError
    end)

    true
  end
end

