require "rails_helper"

RSpec.describe RoutingEngine, type: :model do
  describe "getting next step without routing - additional info" do
    it "when current to next step is incremental" do
      application = AdditionalInfo.new

      expect(described_class.get_next_additional_info_step(application, 1)).to be(2)
      expect(described_class.get_next_additional_info_step(application, 2)).to be(3)
      expect(described_class.get_next_additional_info_step(application, 3)).to be(4)
      expect(described_class.get_next_additional_info_step(application, 4)).to be(5)
    end

    it "when next step is dependent on host question - additional info" do
      application = AdditionalInfo.new

      application.different_address = "No"
      expect(described_class.get_next_additional_info_step(application, 5)).to be(9)
    end

    it "when next step is dependent on more properties question - additional info" do
      application = AdditionalInfo.new

      application.more_properties = "Yes"
      expect(described_class.get_next_additional_info_step(application, 7)).to be(8)
      application.more_properties = "No"
      expect(described_class.get_next_additional_info_step(application, 7)).to be(9)
    end
  end

  describe "getting next step without routing - individual" do
    it "when current to next step is incremental" do
      application = IndividualExpressionOfInterest.new

      expect(described_class.get_next_individual_step(application, 1)).to be(2)
      expect(described_class.get_next_individual_step(application, 2)).to be(3)
      expect(described_class.get_next_individual_step(application, 3)).to be(4)
      expect(described_class.get_next_individual_step(application, 4)).to be(5)
    end

    it "when next step is dependent on host question - individual" do
      application = IndividualExpressionOfInterest.new

      application.different_address = "No"
      expect(described_class.get_next_individual_step(application, 5)).to be(9)
    end
  end

  describe "unaccompanied minors - routing back to task list when a 'section' is complete" do
    it "when name(s) is complete route to task list", :focus do
      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      expect(described_class.get_next_unaccompanied_minor_step(application, 11)).to be(999)
      application.has_other_names = "true"
      expect(described_class.get_next_unaccompanied_minor_step(application, 13)).to be(999)
    end

    it "when contact details is complete route to task list", :focus do
      application = UnaccompaniedMinor.new
      application.phone_number = "07777 123 456"
      expect(described_class.get_next_unaccompanied_minor_step(application, 15)).to be(999)
    end
  end

  describe "getting the next step - unaccompanied minors" do
    it "when next step is dependent on child not living in Ukraine before 31st December 2021" do
      application = UnaccompaniedMinor.new

      application.is_eligible = "false"
      expect(described_class.get_next_unaccompanied_minor_step(application, 2)).to be(3)
      application.is_eligible = "true"
      expect(described_class.get_next_unaccompanied_minor_step(application, 2)).to be(4)
    end

    it "when next step is dependent on sponsor not being a British citizen" do
      application = UnaccompaniedMinor.new

      application.is_eligible = "false"
      expect(described_class.get_next_unaccompanied_minor_step(application, 6)).to be(7)
      application.is_eligible = "true"
      expect(described_class.get_next_unaccompanied_minor_step(application, 6)).to be(8)
    end

    it "when next step is dependent on child living in Ukraine before 31st December 2021 or sponsor being a British citizen" do
      application = UnaccompaniedMinor.new
      application.is_eligible = "true"
      expect(described_class.get_next_unaccompanied_minor_step(application, 1)).to be(2)
      expect(described_class.get_next_unaccompanied_minor_step(application, 2)).to be(4)
      expect(described_class.get_next_unaccompanied_minor_step(application, 4)).to be(5)
      expect(described_class.get_next_unaccompanied_minor_step(application, 5)).to be(6)
      expect(described_class.get_next_unaccompanied_minor_step(application, 6)).to be(8)
      expect(described_class.get_next_unaccompanied_minor_step(application, 8)).to be(9)
    end

    it "when completing names for child - choosing 'Yes' to other names" do
      application = UnaccompaniedMinor.new
      application.has_other_names = "true"
      expect(described_class.get_next_unaccompanied_minor_step(application, 11)).to be(12)
    end
  end
end
