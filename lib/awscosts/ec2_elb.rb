class AWSCosts::ELB

  def initialize data
    @data= data
  end

  def data
    @data
  end

  def price_per_hour
    @data.try(:[], 'perELBHour')
  end

  def price_per_gb
    @data.try(:[], 'perGBProcessed')
  end

  def self.fetch region
    transformed = AWSCosts::Cache.get_jsonp('/pricing/1/elasticloadbalancer/pricing-elb.min.js') do |data|
      result = {}
      data['config']['regions'].each do |r|
        container = {}
        r['types'].each do |type|
          type['values'].each do |value|
            container[value['rate']] = value['prices']['USD'].to_f
          end
        end
        result[r['region']] = container
      end
      result
    end
    self.new(transformed.try(:[],region) || {"perELBHour"=>0.0, "perGBProcessed"=>0.0})
  end

end
