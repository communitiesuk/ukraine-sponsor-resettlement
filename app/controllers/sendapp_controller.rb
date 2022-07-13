class SendappController < ApplicationController
    add_flash_types :error

  

    def post
      @privacyconfirm = PrivacyConfirm.new
      @privacyconfirm.assign_attributes(confirm_params)
     if @privacyconfirm.valid?
       # if they confirm they will be redirected to next page
          redirect_to "/"
     else
       # if they do not confirm reload page and show error
            render "/send-application/data_sharing"
     end
    end
    
    private
    
    def confirm_params
        params.require(:privacy_confirm).permit(:privacy_statement_confirm)
    end
    
end