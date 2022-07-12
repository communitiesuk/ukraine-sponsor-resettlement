class FraudController < ApplicationController
    add_flash_types :error

    def display
      @abstractconfirm = AbstractConfirm.new 
      render "fraud/fraud_page"
    end

    def post
      @abstractconfirm = AbstractConfirm.new 
      @abstractconfirm.assign_attributes(confirm_params)
     if @abstractconfirm.valid?
      ##if they confirm they will be redirected to external file 
      redirect_to "/"
     else
      #if they do not confirm reload page and show error 
      render "fraud/fraud_page"
    end
  end
  
  private

  def confirm_params
    params.require(:abstract_confirm).permit(:confirm_and_continue)
  end
end
