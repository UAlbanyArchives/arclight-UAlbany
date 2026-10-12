require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  tests ApplicationHelper

  test "does not mark a component restricted when an unrestricted phrase is in another paragraph" do
    document = {
      "parent_access_restrict_tesm" => [
        "Sub-series 1.1, 1.3, 3.1, and 3.3 are closed to researchers.",
        "All other material in the collection are open and unrestricted."
      ]
    }

    refute restricted_access?(document)
  end

  test "marks a component restricted when its own access note is restrictive" do
    document = {
      "accessrestrict_tesim" => ["Closed to researchers until 2086."],
      "parent_access_restrict_tesm" => [
        "All other material in the collection are open and unrestricted."
      ]
    }

    assert restricted_access?(document)
  end
end
