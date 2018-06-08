defmodule NanomartError do
  defexception message: "Some error happened"
end

defmodule Restriction do
  @drinking_age 21
  @smoking_age 18

  def drinking_age do
    @drinking_age
  end

  def smoking_age do
    @smoking_age
  end

  defmodule SmokingAge do
    defstruct [:prompter]

    def ck(restriction) do
      age = restriction.prompter.get_age()

      if age >= Restriction.smoking_age do
        true
      else
        false
      end
    end
  end

  defmodule DrinkingAge do
    defstruct [:prompter]

    def ck(restriction) do
      age = restriction.prompter.get_age()

      if age >= Restriction.drinking_age do
        true
      else
        false
      end
    end
  end

  def ck(restriction) do
    case restriction do
      %SmokingAge{} ->
        SmokingAge.ck(restriction)
      %DrinkingAge{} ->
        DrinkingAge.ck(restriction)
    end
  end
end


defmodule Item do
  defmacro __using__(_opts) do
    quote do
      defstruct [:logfile, :prompter]

      def rstrctns(item) do
        []
      end

      defoverridable [rstrctns: 1]
    end
  end

  def try_purchase(success) do
    if success do
      true
    else
      raise NanomartError
    end
  end

  def log_sale(item) do
    File.open(item.logfile, [:append], fn(file) ->
      name = Item.name(item) |> Atom.to_string
      IO.write(file, name <> "\n")
    end)

    true
  end

  # The common case naming doesn't work for miso soup
  def name(%MisoSoup{}) do
    :miso_soup
  end

  def name(item) do
    class = item.__struct__ |> Atom.to_string
    short_class = Regex.replace(~r/Elixir\.Item\./, class, "")
    lower_short_class = String.downcase(short_class)
    lower_short_class |> String.to_atom
  end
end

defmodule Item.Cola do
  use Item

  def rstrctns(cola) do
    []
  end
end

defmodule Item.MisoSoup do
  use Item

  def rstrctns(miso) do
    []
  end
end

defmodule Item.Beer do
  use Item

  def rstrctns(beer) do
    [%Restriction.DrinkingAge{prompter: beer.prompter}]
  end
end

defmodule Item.Whiskey do
  use Item

  def rstrctns(whiskey) do
    [%Restriction.DrinkingAge{prompter: whiskey.prompter}]
  end
end

defmodule Item.Cigarettes do
  use Item

  def rstrctns(cigarettes) do
    [%Restriction.SmokingAge{prompter: cigarettes.prompter}]
  end
end

defmodule Nanomart do
  @moduledoc """
  Nanomart for selling items.
  """

  defstruct [:logfile, :prompter]

  def sell_me(%__module__{} = nanomart, item_name) do
    item = case item_name do
      :cola ->
        %Item.Cola{logfile: nanomart.logfile, prompter: nanomart.prompter}
      :miso_soup ->
        %Item.MisoSoup{logfile: nanomart.logfile, prompter: nanomart.prompter}
      :beer ->
        %Item.Beer{logfile: nanomart.logfile, prompter: nanomart.prompter}
      :whiskey ->
        %Item.Whiskey{logfile: nanomart.logfile, prompter: nanomart.prompter}
      :cigarettes ->
        %Item.Cigarettes{logfile: nanomart.logfile, prompter: nanomart.prompter}
    end

    Enum.map(item.__struct__.rstrctns(item), fn(rstrctn) ->
      Restriction.ck(rstrctn)
      |> Item.try_purchase
    end)

    Item.log_sale(item)
  end
end

