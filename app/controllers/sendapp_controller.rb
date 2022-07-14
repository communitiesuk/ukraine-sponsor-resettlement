class SendappController < ApplicationController
  add_flash_types :error
  def display
    @privacyconfirm = AbstractConfirm.new
    render "/send-application/privacy"
  end 

  def post
    @privacyconfirm = AbstractConfirm.new
    @privacyconfirm.assign_attributes(confirm_params)
    if @privacyconfirm.valid?
      # if they confirm they will be redirected to next page
      render "send-application/eligibility"
    else
      # if they do not confirm reload page and show error
      render "/send-application/privacy"
    end
  end

private

  def confirm_params
    params.require(:abstract_confirm).permit(:privacy_statement_confirm)
  end
end
