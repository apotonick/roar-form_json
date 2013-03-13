require 'test_helper'

class FormTest < MiniTest::Spec
  subject { Object.new.extend(representer) }
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
    subject.to_hash.must_equal [{:type=>:text, :name=>:text, :label=>"Comment (160 chars only)"}, {:type=>:radio, :name=>:rating, :label=>"Was this gem helpful to you?", :data=>[{:value=>1, :src=>"thumb_up.png", :label=>"Hell yeah!"}, {:value=>0, :src=>"thumb_down.png", :label=>"Not really..."}]}, {:type=>:select, :name=>:version, :data=>[{:value=>:current, :selected=>true, :text=>:current}, {:value=>"v0.0.9"}]}]
  end

  describe "::select" do
    representer!(Roar::Representer::JSON::Form) do
      #select :version, :data => [
      #  {:value => :current, selected: true, :text => :current},
      #  {:value => "v0.0.9"}
      #]
    end

    it "provides #options" do
      subject.from_hash([{:type=>:select, :name=>:version, :data=>[{"value"=>"current", "selected"=>true, "text"=>"-- current"}, {"value"=>"v1"}]}])
      subject[:version].options.must_equal [["-- current", "current"], ["v1", "v1"]]
    end
  end

  describe "::radio" do
    let (:form) { subject.from_hash([{:type=>:radio, :name=>:rating, :label=>"Was this gem helpful to you?", :data=>[{:value=>1, :src=>"thumb_up.png", :label=>"Hell yeah!"}, {:value=>0, :src=>"thumb_down.png", :label=>"Not really..."}]}]) }
    it "provides #each implementing Enumerable" do
      form[:rating][0].value.must_equal 1
      form[:rating][1].value.must_equal 0
      form[:rating][2].must_equal nil
      # TODO: test #each, #first, #last.
    end

    it "provides #first" do
      form[:rating].first.value.must_equal 1
    end
  end


  describe "with user options in #to_hash" do
    representer!(Roar::Representer::JSON::Form) do
      select :version do |opts|
        # this should be done in a decorator normally.
        [{:value => opts[:gem].versions.first, :text => "current"}] +
          opts[:gem].versions.collect { |v| {:value => v} }
      end
    end

    it "uses passed options in block" do
      Object.new.extend(representer).to_hash(:gem => OpenStruct.new(:versions => ["v1", "v2"])).must_equal [
        {:type=>:select, :name=>:version, :data=>[{:value=>"v1", :text=>"current"}, {:value=>"v1"}, {:value=>"v2"}]}]
    end
  end

  describe "parsing" do
    subject do
      form = Object.new.extend(Module.new{ include Roar::Representer::JSON::Form })
      form.from_hash([{:type=>:text, "name"=>:text, :label=>"Comment (160 chars only)"}, {:type=>:radio, :name=>:rating, :label=>"Was this gem helpful to you?", :data=>[{:value=>1, :src=>"thumb_up.png", :label=>"Hell yeah!"}, {:value=>0, :src=>"thumb_down.png", :label=>"Not really..."}]}, {:type=>:select, :name=>:version, :data=>[{:value=>:current, :selected=>true, :text=>:current}, {:value=>"v0.0.9"}]}])
      form
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