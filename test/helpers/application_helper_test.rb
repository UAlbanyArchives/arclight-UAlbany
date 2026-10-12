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

  test "matches an unrestricted phrase when indexed access text contains line breaks" do
    document = {
      "parent_access_restrict_tesm" => [
        "To respect the grant guidelines, sub-series 1.1 and 1.3 are closed.\n",
        "All other material in the collection\nare open and unrestricted.\n",
        "Contact an archivist for more details."
      ]
    }

    refute restricted_access?(document)
  end

  test "does not mark files in an open sub-series restricted when inheriting the series note" do
    document = {
      "parent_access_restrict_tesm" => [
        "To respect and fulfill the guidelines of the original National Science Foundation grant which supported the Capital Jury Project, sub-series 1.1 and 1.3 are currently closed to researchers. Sub-series 1.2, which covers the administrative aspects of the CJP Phase I study, is open to researchers.",
        "As an alternative to accessing the closed portions of this sub-series, researchers may also be able to access portions of aggregate data."
      ]
    }

    refute restricted_access?(document)
  end

  test "uses the full note of the nearest ancestor instead of the truncated parent field" do
    document = {
      "parent_ids_ssim" => ["apap196"],
      "parent_access_restrict_tesm" => ["Please contact an archivist for more details."]
    }
    define_singleton_method(:nearest_ancestor_access_notes) do |_doc|
      ["Some sub-series are closed.", "All other material in the collection are open and unrestricted."]
    end

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

  test "identifies an unprocessed restriction in a parent access note" do
    document = {
      "parent_access_restrict_tesm" => [
        "Access to this collection is restricted because it is unprocessed."
      ]
    }

    assert unprocessed_access?(document)
  end

  test "does not use the parent unprocessed note when the component has its own restriction" do
    document = {
      "accessrestrict_tesim" => ["Closed to researchers until 2086."],
      "parent_access_restrict_tesm" => [
        "Access to this collection is restricted because it is unprocessed."
      ]
    }

    refute unprocessed_access?(document)
  end

  test "does not mark an unrestricted component restricted when its parent is unprocessed" do
    document = {
      "accessrestrict_tesim" => ["This item is unrestricted."],
      "parent_access_restrict_tesm" => [
        "Access to this collection is restricted because it is unprocessed."
      ]
    }

    refute restricted_access?(document)
    refute unprocessed_access?(document)
  end
end
