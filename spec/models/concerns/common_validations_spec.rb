RSpec.describe CommonValidations, type: :helper do
  describe "name validation" do
    it "returns false when name is not valid" do
      test_values = [nil, "", " ", "!", "$", "£", "A" * 129].freeze

      test_values.each do |val|
        expect(name_valid?(val)).to be(false), "Failed value:#{val.inspect}"
      end
    end

    it "returns true when name is valid" do
      test_values = ["a", "AB", "apos'ok", "Spaces OK", "Hypens-OK"].freeze

      test_values.each do |val|
        expect(name_valid?(val)).to be(true), "Failed value:#{val.inspect}"
      end
    end
  end

  describe "email validation" do
    it "returns false when email is not valid" do
      test_values = [nil, "", " ", "!", "$", "£", "A" * 129].freeze

      test_values.each do |val|
        expect(email_address_valid?(val)).to be(false), "Failed value:#{val.inspect}"
      end
    end

    it "returns true when email is valid" do
      test_values = ["a@b.it",
                     "hello_world@a.it",
                     "freddy+smith@gmail.com",
                     "test.email-some+name@example.com",
                     "me@a-very-long-domain.it"].freeze

      test_values.each do |val|
        expect(email_address_valid?(val)).to be(true), "Failed value:#{val.inspect}"
      end
    end
  end
end
