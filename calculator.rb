class Calculator
  def calculate
    raise NotImplementedError
  end

  def self.get_endpoint
    @endpoint || self.name.downcase
  end

  protected
  def self.endpoint(name)
    @endpoint = name.downcase
  end
end

module Calculators
  def self.instances
    @@instances
  end

  def self.all
    ObjectSpace.each_object(Class).select { |clazz| clazz < Calculator }
  end

  def self.setup
    Dir['./calculators/*.rb'].each { |file| require file }

    classes = all
    duplicate_endpoints = classes - classes.uniq { |clazz| clazz.get_endpoint }
    duplicate_endpoints.each { |clazz| raise "Duplicate endpoint `#{clazz.get_endpoint}' in class `#{clazz.name}'" }

    @@instances = classes.map { |clazz| clazz.new }
  end

  def self.get_endpoint(name)
    instances.find { |endpoint| endpoint.class.get_endpoint === name }
  end
end
