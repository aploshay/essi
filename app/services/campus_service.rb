module CampusService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Campuses.new

  def self.select_options
    authority.all.map { |element| [element[:label], element[:code]] }.sort
  end

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:code]]
    end
  end

  def self.find(id)
    authority.find(id)
  end

  def self.campuses
    authority.all.map { |element| Campus.new(element) }
  end

  class Campus
    attr_accessor :label, :code, :img_src, :img_alt

    def initialize(values)
      @label = values[:label]
      @code = values[:code]
      @img_src = values[:img_src]
      @img_alt = values[:img_alt]
    end
  end
end
