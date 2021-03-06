require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

test "product is not valid without a unique title" do
	product = Product.new(title: products(:ruby).title, description: "yyy", price: 1, image_url: "ruby.png")
	assert product.invalid?
	assert_equal [I18n.translate('activerecord.errors.messages.taken')], product.errors[:title]
end



test "product attributes must not be empty" do
	product = Product.new
	assert product.invalid?
	assert product.errors[:title].any?
	assert product.errors[:description].any?
	assert product.errors[:price].any?
	assert product.errors[:image_url].any?
end

test "product price must be positive" do
	product = Product.new(title: "Title", description: "description", image_url: "jsj.jpg")
	product.price = -1
	assert product.invalid?
	assert_equal ["must be greater than or equal to 0.01"],	product.errors[:price]

	product.price = 0
	assert product.invalid?
	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

	product.price = 1
	assert product.valid?
end

def new_product(image_url)
	Product.new(title: "Title", description: "description", price: 1, image_url: image_url)
end

test "image url" do
	ok = %w{ fred.gif rec.jpg sex.png SAD.jpg http://a.b.c/x/y/z/frenk.jpg }
	bad = %w{ panch.doc dsa.mp3 bummazafaca.flac }

	ok.each do |name|
		assert new_product(name).valid?, "#{name} shouldn't be invalid"
	end

	bad.each do |name|
		assert new_product(name).invalid?, "#{name} shouldn't be valid"
	end
end

end
