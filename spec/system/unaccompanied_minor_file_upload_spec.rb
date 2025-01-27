RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine".freeze }
  let(:malicious_file_message) { "The uploaded file has been detected as malicious. Please upload a different file".freeze }

  before do
    driven_by(:rack_test_user_agent)
    new_application = UnaccompaniedMinor.new
    new_application.save!

    page.set_rack_session(app_reference: new_application.reference)
    visit "/sponsor-a-child/task-list"
  end

  describe "submitting the form for child's flow" do
    it "saves all the UK parent consent form to the database" do
      expect(page).to have_content(task_list_content)
      click_link("Upload UK consent form")
      expect(page).to have_content("You must upload 2 completed parental consent forms")
      click_button("Continue")

      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")
      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "saves all the Ukraine parent consent form to the database" do
      expect(page).to have_content(task_list_content)
      click_link("Upload Ukrainian consent form")
      expect(page).to have_content("Upload the Ukraine certified consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")
      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "gets rejected trying to upload a file that's too large UK" do
      expect(page).to have_content(task_list_content)
      click_link("Upload UK consent form")
      expect(page).to have_content("You must upload 2 completed parental consent forms")
      click_button("Continue")

      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "test-file-too-large.png")
      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content("Your file must be smaller than 20MB")
    end

    it "gets rejected trying to upload a file that's too large Ukraine" do
      expect(page).to have_content(task_list_content)
      click_link("Upload Ukrainian consent form")

      expect(page).to have_content("Upload the Ukraine certified consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "test-file-too-large.png")

      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content("Your file must be smaller than 20MB")
    end

    it "gets rejected trying to upload a malicious UK consent form" do
      expect(page).to have_content(task_list_content)
      click_link("Upload UK consent form")
      expect(page).to have_content("You must upload 2 completed parental consent forms")
      click_button("Continue")

      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      begin
        malicious_file = make_malicious_file
        attach_file("unaccompanied-minor-uk-parental-consent-field", malicious_file.path)
        click_button("Continue")

        expect(page).to have_content(malicious_file_message)
      ensure
        malicious_file.close
        malicious_file.unlink
      end
    end

    it "gets rejected trying to upload a malicious UK consent form" do
      expect(page).to have_content(task_list_content)
      click_link("Upload Ukrainian consent form")

      expect(page).to have_content("Upload the Ukraine certified consent form")

      begin
        malicious_file = make_malicious_file
        attach_file("unaccompanied-minor-ukraine-parental-consent-field", malicious_file.path)
        click_button("Continue")

        expect(page).to have_content(malicious_file_message)
      ensure
        malicious_file.close
        malicious_file.unlink
      end
    end
  end
end
