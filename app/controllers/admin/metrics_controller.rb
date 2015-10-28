class Admin::MetricsController < Admin::BaseController
  def index
    @metrics = MetricsPresenter.new
  end
end
