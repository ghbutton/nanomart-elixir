defmodule NanomartTest do
  use ExUnit.Case
  doctest Nanomart

  defmodule Age9 do
    def get_age do
      9
    end
  end

  defmodule Age19 do
    def get_age do
      19
    end
  end

  describe "make sure the customer is old enough" do
    test "when you're a kid" do
      nanomart = %Nanomart{logfile: "/dev/null", prompter: Age9}

      assert Nanomart.sell_me(nanomart, :cola) == true
      assert Nanomart.sell_me(nanomart, :miso_soup) == true

      assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :beer) end
      assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :whiskey) end
      assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :cigarettes) end
    end

    test "when you're a newly minted adult" do
      nanomart = %Nanomart{logfile: "/dev/null", prompter: Age19}

      assert Nanomart.sell_me(nanomart, :cola) == true
      assert Nanomart.sell_me(nanomart, :miso_soup) == true
      assert Nanomart.sell_me(nanomart, :cigarettes) == true

      assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :beer) end
      assert_raise NanomartError, fn -> Nanomart.sell_me(nanomart, :whiskey) end
    end
  end
end
