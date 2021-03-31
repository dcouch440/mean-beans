class Seed

  def self.begin
    Coffee.destroy_all
    seed = Seed.new
    seed.generate_coffees
    User.create
  end

  def generate_coffees
    FactoryBot.create_list(:coffee, 50)
    puts "Created #{Coffee.count} coffees."
  end

end

Seed.begin
