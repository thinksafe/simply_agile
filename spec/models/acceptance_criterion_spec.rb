require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AcceptanceCriterion do
  before(:each) do
    AcceptanceCriterion.delete_all
    @valid_attributes = {
      :story_id => "1",
      :criterion => "value for name",
      :fulfilled_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    AcceptanceCriterion.create!(@valid_attributes)
  end

  describe "validations" do
    before :each do
      @acceptance_criterion = AcceptanceCriterion.new
      @acceptance_criterion.valid?
    end

    it "should require a criterion" do
      @acceptance_criterion.errors.on(:criterion).should_not be_nil
    end

    it "should require a unique criterion within the scope of the story" do
      @acceptance_criterion.story_id = 1
      @acceptance_criterion.criterion = 'asdf'
      @acceptance_criterion.save!

      new_acceptance_criterion = AcceptanceCriterion.new
      new_acceptance_criterion.story_id = 1
      new_acceptance_criterion.criterion = 'asdf'
      new_acceptance_criterion.valid?
      new_acceptance_criterion.errors.on(:criterion).should_not be_nil
    end

    it "should require a story" do
      @acceptance_criterion.errors.on(:story_id).should_not be_nil
    end
  end

  describe "completion" do
    before :each do
      @acceptance_criterion = AcceptanceCriterion.new
    end

    it "should be complete if fulfilled_at is set" do
      @acceptance_criterion.fulfilled_at = Time.now
      @acceptance_criterion.complete?.should be_true
    end

    it "should not be complete if fulfilled_at is nil" do
      @acceptance_criterion.complete?.should be_false
    end

    it "should set fulfilled_at if complete is set to true" do
      time = Time.now
      Time.stub!(:now).and_return(time)
      @acceptance_criterion.complete = "true"
      @acceptance_criterion.fulfilled_at.should == time
    end

    it "should not overwrite fulfilled_at if complete is set to true" do
      time = Time.now
      @acceptance_criterion.fulfilled_at = time
      @acceptance_criterion.complete = "true"
      @acceptance_criterion.fulfilled_at.should == time
    end

    it "should not unset fulfilled_at if complete is set to false" do
      @acceptance_criterion.fulfilled_at = Time.now
      @acceptance_criterion.complete = "false"
      @acceptance_criterion.fulfilled_at.should be_nil
    end
  end
end
