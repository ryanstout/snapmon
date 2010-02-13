class SnapmonController < ActionController::Base
  session :off unless Rails::VERSION::STRING >= "2.3"

	
  def index
    if (ActiveRecord::Base.connection.execute("select 1 from dual").num_rows rescue 0) == 1
      render :text => "UP"
    else
      render :text => 'DOWN: Database', :status => :internal_server_error
    end
  end

	# Disable logger
  def logger
    nil
  end
end
