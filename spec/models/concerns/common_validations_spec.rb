RSpec.describe CommonValidations, type: :helper do
  describe "name validation" do
    it "returns false when name is not valid" do
      invalid_names = [nil, "", " ", "!", "$", "£", "A" * 129].freeze

      invalid_names.each do |name|
        expect(is_valid_name?(name)).to be(false), "Failed value:#{name.inspect}"
      end
    end

    it "returns true when name is valid" do
      valid_names = ["a", "AB", "apos'ok", "Spaces OK", "Hypens-OK"].freeze

      valid_names.each do |name|
        expect(is_valid_name?(name)).to be(true), "Failed value:#{name.inspect}"
      end
    end
  end
end
