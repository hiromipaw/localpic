require 'test_helper'
require "benchmark"

class ImageFilterTest < ActiveSupport::TestCase
  setup do
    @image = "#{Rails.root}/test/fixtures/files/himalayas.jpg"
    ImageFilter.jobs.clear
  end

  test 'image_filter_worker' do
    Sidekiq::Testing.fake!
    ImageFilter.perform_async(1)
    assert_equal 1, ImageFilter.jobs.size
    ImageFilter.jobs.clear
  end

  test 'apply_filter_to_image' do
    result = "#{Rails.root}/test/fixtures/files/result.jpg"
  end

end
