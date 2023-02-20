class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    # status 201
    # render plain: "Plain text response"
    # headers['Content-Type'] = 'text/plane'
  end

  def create; end

  def show
    @test = Test.where(id: params[:id]).first
  end
end
