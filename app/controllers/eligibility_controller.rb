class EligibilityController < ApplicationController
    add_flash_types :error
  
    def post
      @eligableconfirm = AbstractConfirm.new
      @eligableconfirm.assign_attributes(confirm_params)
      if @eligableconfirm.valid?
        # if they confirm they will be redirected to next page
        redirect_to "/unaccompanied-minor/check-answers"
      else
        # if they do not confirm reload page and show error
        render "/send-application/sponsor_declaration"
      end
    end
  
  private
  
    def confirm_params
      params.require(:eligable_confirm).permit(:eligable_statement_confirm)
    end
  end
  