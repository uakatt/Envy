class Environment < ActiveRecord::Base
  has_many :melodie_snapshots

  def default_url
    if code =~ /(\w+)[ \-](\w+)/
      app = $1.downcase
      name = $2.downcase
      app = 'kra' if app == 'kc'
      "https://#{app[0,2]}-#{name}.mosaic.arizona.edu/#{app}-#{name}"
    end
  end
end
