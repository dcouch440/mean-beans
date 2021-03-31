class Seed

  def self.begin
    Coffee.destroy_all
    seed = Seed.new
    seed.generate_coffees
    Seed.generate_user
  end

  def generate_coffees
    FactoryBot.create_list(:coffee, 50)
    puts "Created #{Coffee.count} coffees."
  end

  def generate_user
    User.create
  end
end

Seed.begin
