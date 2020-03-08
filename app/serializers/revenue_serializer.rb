class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
    (object.revenue / 100.0).to_s
  end
end
