# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

require 'slab/all'

class SlabTest < ActiveSupport::TestCase
  
  test 'enumerable extension: hmap' do
    assert_equal Hash['a' => 'b', 'b' => 'c'], ['a', 'b'].hmap(&:succ)
  end

  test 'hash extension: hmap' do
    block_args = []
    block = ->(k, v) { block_args << [k, v]; v**2 }
    assert_equal({ a: 1, b: 4, c: 9 }, { a: 1, b: 2, c: 3 }.hmap(&block))
    assert_equal [[:a, 1], [:b, 2], [:c, 3]], block_args
  end
  
  test 'hash extension: hmap_pair' do
    assert_equal Hash['aaa' => 3, 'bbb' => 6], { :a => 1, :b => 2 }.hmap_pair { |k, v| [k.to_s * 3, v * 3] }  
  end
  
  test 'enumerable extension: hmap_pair' do
    assert_equal Hash['a' => 'c', 'b' => 'd'], %w(a b).hmap_pair { |k, v| [k, k.succ.succ] }
  end

  test 'hash extension: extract' do
    assert_equal({ a: 1, b: 2 }, { :a => 1, :aa => 1.5, :b => 2, 'c' => 3, :c => '4' }.extract(:a, :b))
  end
  
  test 'numeric extension: percent' do
    assert_float_equal 0.123, 12.3.percent
    assert_float_equal 2, 200.percent
    assert_float_equal 999.9, BigDecimal.new('99990.0000').percent
  end
  
  test 'numeric extension: discount' do
    assert_float_equal 0.8, 1.0.discount(20.percent)
    assert_float_equal 200, BigDecimal.new('400.0').discount(50.percent)
    assert_raise(Numeric::DiscountTooBig) { 10.discount(101.percent) }
  end
  
  test 'numeric extension: net' do
    assert_float_equal 1.0, 1.19.net(19.percent)
    assert_float_equal 100, BigDecimal.new('107.0').net(7.percent)
  end
  
  test 'numeric extension: gross' do
    assert_float_equal 1.19, 1.0.gross(19.percent)
    assert_float_equal 10.7, BigDecimal.new('10').gross(7.percent)
  end
  
  test 'numeric extension: tax' do
    assert_float_equal 0.19, 1.0.tax(19.percent)
    assert_float_equal 70, BigDecimal.new('1000').tax(7.percent)
  end
  
  test 'numeric extension: sgn' do
    assert_equal 1, 1.sgn
    assert_equal 0, 0.0000000.sgn
    assert_equal -1, BigDecimal.new('-345345345.45345345').sgn
  end
  
  test 'numeric extension: commercial round' do
    assert_equal 1.23, 1.234999.commercial_round
    assert_equal -34.44, -34.44223.commercial_round
  end
  
  test 'methodphitamine' do
    assert_equal [1, 4, 9], (1..3).map(&it ** 2)
    assert_equal [true, true, false], [-4, 0, 4].map(&its <= 0)
    assert_equal [false, false, true, false], %w(a aaa aaaa aaaaa).map(&its.size.even?)
    assert_equal ['F', 'O', 'U'], %w(af bo cu) .map(&its[1].upcase)
  end
  
  test 'methodphitamine captures the equality operator' do
    assert_equal [true, false, true], ['1', :f, 'F'].map(&its.class.name == 'String')
  end
  
  test 'date extension: epoch' do
    assert_equal '1000-01-01'.to_date, Date.epoch(:db)
    assert_equal '1970-01-01'.to_date, Date.epoch
  end
  
  test 'date extension: end of month' do
    assert_equal true, '2012-02-29'.to_date.end_of_month?
    assert_equal false, '2012-02-28'.to_date.end_of_month?
    assert_equal true, '1999-12-31'.to_date.end_of_month?
    assert_nothing_raised do
      '2012-02-28'.to_date.on_end_of_month do
        raise
      end
    end
    dummy_error = Class.new(Exception)
    assert_raise(dummy_error) do
      '2012-03-31'.to_date.on_end_of_month do
        raise dummy_error
      end
    end  
  end
  
  test 'enumerable extension: any not?' do
    klass = callable_class
    array = (1..5).map { |n| klass.new(n) }
    assert_equal true, array.any_not? { |obj| obj.value < 3 }
    assert_equal [true, true, true, false, false], array.map(&:touched?)
  end
  
  test 'enumerable extension: none?' do
    klass = callable_class
    array = (1..5).map { |n| klass.new(n) }
    assert_equal false, array.none? { |obj| obj.value > 3 }
    assert_equal [true, true, true, true, false], array.map(&:touched?)
  end
  
  test 'enumerable extension: map with index' do
    assert_equal [0, 1, 2], (3..5).map_with_index { |obj, idx| idx }
  end
  
  test 'enumerable extension: inject with index' do
    assert_equal 'a0b1c2', ['a', 'b', 'c'].inject_with_index('') { |memo, object, index| memo << "#{object}#{index}" }
  end
  
  test 'big decimal extension: readable inspect' do
    number = '1030345345345.34534535'
    assert BigDecimal.new(number).inspect.match(/#{Regexp.escape(number)}>\z/)
  end
  
  test 'module extension: basename' do
    assert_equal 'Testing', ActiveSupport::Testing.basename
    assert_equal 'Assertions', ActiveSupport::Testing::Assertions.basename
  end
  
  test 'string extension: to_iso' do
    assert_equal "f\xF6\xF6b\xE4r".force_encoding('iso-8859-1'), 'fööbär'.to_iso
    assert_equal '50 ?'.force_encoding('iso-8859-1'), "50 €".to_iso
  end
  
  private
  
  def callable_class
    Class.new(Object) do
      define_method 'initialize' do |value|
        @value = value
      end
      define_method 'value' do
        @touched = true
        @value
      end
      define_method 'touched?' do
        !!@touched
      end
    end
  end
  
end
