class MatchController < ApplicationController
  def display
    reference = params["reference"]

    if reference.match(/ANON-\w{4}-\w{4}-\w{1}/)
      render "match/start"
    else
      redirect_to "/match"
    end
  end
end
