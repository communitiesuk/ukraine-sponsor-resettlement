class AdditionalController < ApplicationController
  def display
    reference = params["reference"]

    if reference.present? && reference.upcase.match(/ANON-\w{4}-\w{4}-\w{1}/)
      render "additional-info/start"
    else
      redirect_to "/additional-info"
    end
  end
end
