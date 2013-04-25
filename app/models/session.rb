class Session
  include Mongoid::Document
  include Mongoid::Timestamps #use updated_at a lot

  field :facebook_uid, :type => String
  field :facebook_name, :type => String
  field :track_id, :type => String
  field :track_name, :type => String
  field :seconds_passed, :type => String
  field :num_listening, :type => String, :default => 0

end
