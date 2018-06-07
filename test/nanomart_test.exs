defmodule NanomartTest do
  use ExUnit.Case
  doctest Nanomart

  defmodule Age9 do
    def get_age do
      9
    end
  end

  test "make sure the customer is old enough" do
    nanomart = %Nanomart{output: "/dev/null", prompter: Age9}

    assert Nanomart.sell_me(nanomart, :cola) == true
    assert Nanomart.sell_me(nanomart, :miso_soup) == true

    assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :beer) end
    assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :whiskey) end
    assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :cigarettes) end
  end
end
