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

  describe "parsing" do
    subject do
      form = Object.new.extend(representer)
      form.from_hash([{:type=>:text, :name=>:text, :label=>"Comment (160 chars only)"}, {:type=>:radio, :name=>:rating, :label=>"Was this gem helpful to you?", :data=>[{:value=>1, :src=>"thumb_up.png", :label=>"Hell yeah!"}, {:value=>0, :src=>"thumb_down.png", :label=>"Not really..."}]}, {:type=>:select, :name=>:version, :data=>[{:value=>:current, :selected=>true, :text=>:current}, {:value=>"v0.0.9"}]}])
      form
    end
    
    it "provides #element reader" do
      subject.element(:text)[:label].must_equal "Comment (160 chars only)"
    end
    
  end
end