class SessionController < ApplicationController

  before_filter :session, :except => ["create","list"]
  def create
    @rest = Koala::Facebook::API.new(params[:accesstoken])
    @fql = @rest.fql_query("SELECT uid, name FROM user where uid = me()")
    @session = Session.create(
      :facebook_uid => @fql.data.uid
      :facebook_name => @fql.data.name
      :track_id => params[:track]
      :track_name => params[:track_name]
      :seconds_passed => params[:seconds_passed]
    )
    render json: @session
  end

  def update
    @session.track_id = params[:track]
    @session.seconds_passed = params[:seconds_passed] + (Time.now.getutc - params[:timestamp])
    @session.save
    render json: @session
  end

  def destroy
    #has to be auth.
    @session.destroy
    render json: nil
  end

  def list
    @rest = Koala::Facebook::API.new(params[:accesstoken])
    @fql = @rest.fql_query("SELECT uid FROM user WHERE is_app_user AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())
")
    @sessions = Session.any_in(:facebook_uid => @fql.data.map { |x| x.uid })
    render json: @sessions
  end

  def get 
    render json: @session
  end
  def join
    @session.num_listening += 1
    @session.save
    render json: @session
  end

  def leave
    @session.num_listening -= 1
    @session.save
    render json:  nil
  end

  protected

  def session 
    @session = Session.find(params[:session_id])
  end

end
