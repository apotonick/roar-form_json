require 'test_helper'

class FormTest < MiniTest::Spec
  representer!(Roar::Representer::JSON::Form) do
    text :text, :label => "Comment (160 chars only)"

    radio :rating, :label => "Was this gem helpful to you?", :data => [
      {value: 1, src: "thumb_up.png", label: "Hell yeah!"},
      {value: 0, src: "thumb_down.png", label: "Not really..."}
    ]

    select :version, :data => [
      {:value => :current, selected: true, :text => :current},
      {:value => "v0.0.9"}
    ]
  end

  it "renders" do
    Object.new.extend(representer).to_hash.must_equal [{:type=>:text, :name=>:text, :label=>"Comment (160 chars only)"}, {:type=>:radio, :name=>:rating, :label=>"Was this gem helpful to you?", :data=>[{:value=>1, :src=>"thumb_up.png", :label=>"Hell yeah!"}, {:value=>0, :src=>"thumb_down.png", :label=>"Not really..."}]}, {:type=>:select, :name=>:version, :data=>[{:value=>:current, :selected=>true, :text=>:current}, {:value=>"v0.0.9"}]}]
  end

  describe "with user options" do
    representer!(Roar::Representer::JSON::Form) do
      select :version do |opts|
        # this should be done in a decorator normally.
        [{:value => opts[:gem].versions.first, :text => "current"}] +
          opts[:gem].versions.collect { |v| {:value => v} }
      end
    end

    it "uses passed options in block" do
      Object.new.extend(representer).to_hash(:gem => OpenStruct.new(:versions => ["v1", "v2"])).must_equal [{:type=>:select, :name=>:version, :data=>[{:value=>"v1", :text=>"current"}, {:value=>"v1", :text=>"v1"}, {:value=>"v2", :text=>"v2"}]}]
    end
  end

  describe "parsing" do
    subject do
      form = Object.new.extend(Module.new{ include Roar::Representer::JSON::Form })
      form.from_hash([{:type=>:text, "name"=>:text, :label=>"Comment (160 chars only)"}, {:type=>:radio, :name=>:rating, :label=>"Was this gem helpful to you?", :data=>[{:value=>1, :src=>"thumb_up.png", :label=>"Hell yeah!"}, {:value=>0, :src=>"thumb_down.png", :label=>"Not really..."}]}, {:type=>:select, :name=>:version, :data=>[{:value=>:current, :selected=>true, :text=>:current}, {:value=>"v0.0.9"}]}])
      form
    end

    it "provides #elements" do
      
    end
  end

  describe "#[]" do
    subject { Object.new.extend(Module.new{ include Roar::Representer::JSON::Form }) }

    it "works with incoming symbols" do
      subject.from_hash [{:type=>:text, :name=>:comment, :label=>"Comment (160 chars only)"}]
      subject[:comment].type.must_equal :text
    end

    it "works with incoming strings" do
      subject.from_hash [{"type"=>:text, "name"=>"comment", "label"=>"Comment (160 chars only)"}]
      subject[:comment].type.must_equal :text
    end

    it "works with incoming symbol values" do
      subject.from_hash [{:type=>:text, "name"=>:comment, :label=>"Comment (160 chars only)"}]
      subject[:comment].type.must_equal :text
    end
  end
end