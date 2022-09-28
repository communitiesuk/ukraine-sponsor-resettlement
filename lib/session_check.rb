class SessionCheck
  def initialize(app)
    @app = app
  end

  def call(env)
    # Check that the user's session contains correct data to be valid.
    # Many of the controllers for UAM require app_reference to be present
    # in the user's session. If the required data is not present, redirect
    # the user to the start of the UAM journey.

    if sessioncheck(env)
      @app.call(env)
    else
      [302, { "Location" => "/sponsor-a-child" }, []]
    end
  end

  def sessioncheck(env)
    # If incoming request path matches any of the regexps below and
    # if the user's session does not have an app_reference then
    # return false, else return true

    reference_required_paths = [
      /\/sponsor-a-child\/task-list/,
      /\/sponsor-a-child\/save_or_cancel/,
      /\/sponsor-a-child\/cancel-application/,
      /\/sponsor-a-child\/check-answers/,
      /\/sponsor-a-child\/upload-uk\/\d+/,
      /\/sponsor-a-child\/upload-ukraine\/\d+/,
      /\/sponsor-a-child\/remove\/\w+/,
      /\/sponsor-a-child\/remove-other-name\/\w+\/\w+/,
      /\/sponsor-a-child\/remove-other-nationality\/\w+/,
    ]

    session_ok = true
    reference_required_paths.each do |re|
      if env["PATH_INFO"].match?(re) && env["rack.session"][:app_reference].blank?
        session_ok = false
      end
    end
    session_ok
  end
end
